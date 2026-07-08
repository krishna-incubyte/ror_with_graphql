module Mutations
  class CreateUser < BaseMutation
    argument :first_name, String, required: true
    argument :last_name, String, required: false
    argument :dob,  GraphQL::Types::ISO8601Date, required: true
    argument :role, String, required: true
    argument :gender, String, required: true

    type Types::UserType

    def resolve(first_name:, last_name:, dob:, role:, gender:)
      User.create!(
        first_name: first_name,
        last_name: last_name,
        dob: dob,
        role: role,
        gender: gender
      )
    end
  end
end