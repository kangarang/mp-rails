UserType = GraphQL::ObjectType.define do
    name 'User'
    description 'One user'

    field :id, !types.ID
    field :firstName, !types.String, property: :first_name
    field :lastName, !types.String, property: :last_name
    field :email, !types.String
    field :username, !types.String
    field :id, !types.String
    field :matches do
        type -> { types[UserType] }
        resolve -> (user, args, ctx) { user.matches }
        # The `resolve()` method takes a source, args, context, and an info argument
        # and must return either a value conforming to the type of the field it's resolving, or a Promise that resolves to that value.
        # You can inspect the types of the four arguments in detail here:
        # https://github.com/graphql/graphql-js/blob/master/src/type/definition.js#L469-L486
    end
end

QueryType = GraphQL::ObjectType.define do
    
    name 'Query'
    description 'the root of all queries'

    field :user do
        type UserType
        argument :id, !types.ID
        # argument :id, !types.String
        resolve -> (root, args, ctx) { User.find(args[:id]) }
    end

    field :allUsers do
        type types[UserType]
        description 'everyone in the universe!'
        resolve -> (root, args, ctx) { User.all }
    end

end

SuperSchema = GraphQL::Schema.define do
    query QueryType
end
