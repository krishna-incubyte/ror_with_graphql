module Mutations
  class UpdateUser < BaseMutation
    argument :id, ID, required: true
    argument :first_name, String, required: true
    argument :last_name, String, required: false
    argument :dob,  GraphQL::Types::ISO8601Date, required: true
    argument :role, String, required: true
    argument :gender, String, required: true

    type Types::UserType

    def resolve(id: ,first_name:, last_name:, dob:, role:, gender:)
      user = User.find_by(id: id)
      return GraphQL::ExecutionError.new("User not found") if user.nil?

      begin
        user.update!(first_name: first_name, last_name: last_name, dob: dob, role: role, gender: gender)
        user
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end