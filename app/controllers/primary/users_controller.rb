class Primary::UsersController < ApplicationController
  def index
    ids = params[:ids]
    with_contact = params.key?(:with_contact)
    eager_load_opt = with_contact ? [:contacts] : []
    available_order_options = { "id_desc" => { id: :desc }, "date_desc" => [{ date: :desc }] }
    default_order_option = available_order_options["id_desc"]
    order_option = available_order_options[params[:order]] || default_order_option

    users = User.eager_load(eager_load_opt)
                .then { ids ? _1.where(id: ids) : _1 }
                .order(order_option)
                .page(page_params[:page])
                .per(page_params[:per])

    render json: {
      users: with_contact ? users.as_json(include: :contacts) : users,
      pagination: { per: users.limit_value, total_counts: users.total_count, total_pages: users.total_pages }
    }
  end

end
