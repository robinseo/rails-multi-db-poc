class ReadOnly::UsersController < ApplicationController
  around_action :use_readonly, only: :index_with_around_action

  def index_with_around_action
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

  def index_with_block
    ids = params[:ids]
    with_contact = params.key?(:with_contact)
    eager_load_opt = with_contact ? [:contacts] : []
    available_order_options = { "id_desc" => { id: :desc }, "date_desc" => [{ date: :desc }] }
    default_order_option = available_order_options["id_desc"]
    order_option = available_order_options[params[:order]] || default_order_option

    users = nil
    ActiveRecord::Base.connected_to(role: :reading) do
      # 루비의 블록은 스코프가 없어서 이게 됨..
      users = User.eager_load(eager_load_opt)
                  .then { ids ? _1.where(id: ids) : _1 }
                  .order(order_option)
                  .page(page_params[:page])
                  .per(page_params[:per])

    end

    # users = ActiveRecord::Base.connected_to(role: :reading) { User.blah.... }  이렇게도 가능은 함. 블록의 마지막 값을 리턴해서 users에 assign하는거라서.

    render json: {
      users: with_contact ? users.as_json(include: :contacts) : users,
      pagination: { per: users.limit_value, total_counts: users.total_count, total_pages: users.total_pages }
    }
  end

  def index_with_proxy_class
    ids = params[:ids]
    with_contact = params.key?(:with_contact)
    eager_load_opt = with_contact ? [:contacts] : []
    available_order_options = { "id_desc" => { id: :desc }, "date_desc" => [{ date: :desc }] }
    default_order_option = available_order_options["id_desc"]
    order_option = available_order_options[params[:order]] || default_order_option

    users = User.use_readonly
                .eager_load(eager_load_opt)
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
