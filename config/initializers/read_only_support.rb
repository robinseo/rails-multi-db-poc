module ReadOnlySupport
  def use_readonly
    Class.new(self) do
      default_scope { readonly }

      def self.connection
        ActiveRecord::Base.connected_to(role: :reading, prevent_writes: true) { super }
      end

      ActiveRecord::Base.instance_methods
                        .select { |m| m =~ /(update|create|destroy|delete|save)[^\?]*$/ }
                        .each { |m| define_method(m) { |*args| raise ActiveRecord::ReadOnlyRecord } }

    end
  end
end

ActiveSupport.on_load(:active_record) do
  extend ReadOnlySupport
end
