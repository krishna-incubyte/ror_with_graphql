module Mutations
  class DeleteUser < BaseMutation
    argument :id, ID, required: true

    field :success, String, null: true
    field :errors, [String], null: false

    def resolve(id: )
      user = User.find_by(id: id)
      if user.destroy
        { success: "User #{user.first_name} sucessfully destroyed", errors: [] }
      else
        { errors: "User cannot be deleted #{user.errors.full_messages}"}
      end
    end
  end
end