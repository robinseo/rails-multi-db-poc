class UsersController < ApplicationController
  def update_on_readonly_block
    user = nil
    ActiveRecord::Base.connected_to(role: :reading) do # ActiveRecord::ReadOnlyError (Write query attempted while in readonly mode: )
      user = User.find(1)
      user.update!(name: "Hello")
    end
  end

  def read_on_block_then_update
    user = nil
    ActiveRecord::Base.connected_to(role: :reading) do
      user = User.find(1) # Read on Replica Database
    end
    user.update!(name: "Hello") # It Only updates on Primary Database
    user.contacts.last.update!(name: "Telephone") # It updates on Primary Database Too

    render json: {user: user.as_json(include: :contacts)} # Then Read on Primary Database again
  end
end
