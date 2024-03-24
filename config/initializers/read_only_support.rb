module ReadOnlySupport
  def use_readonly
    Class.new(self) do
      def self.connection
        ActiveRecord::Base.connected_to(role: :reading) { super }
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  extend ReadOnlySupport
end
