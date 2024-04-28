require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
    path '/api/v1/signup' do
        post 'Creates a new user' do
            tags 'Users'
            consumes 'application/json'
            parameter name: :user, in: :body, schema: {
            type: :object,
            properties: {
                username: { type: :string },
                email: { type: :string },
                password: { type: :string },
                gender: { type: :string },
                date_of_birth: { type: :string, format: :date }
            },
            required: ['username', 'email', 'password', 'gender']
            }
    
            response '200', 'Signed up successfully' do
                let(:user) { { username: 'testuser', email: 'test@example.com', password: 'password', gender: 'male' } }
                run_test!
            end

            response '422', "User couldn't be created successfully. Email has already been taken, Password can't be blank, Username has already been taken, Email has already been taken, and Gender can't be blank" do
                let(:user) { { username: 'testuser', email: 'test@example.com', password: '', gender: '' } }
                run_test!
            end
        end
    end
  
    path '/api/v1/current_user' do
        get 'Retrieves the currently logged-in user' do
            tags 'Users'
            produces 'application/json'
            security [Bearer: {}]
    
            response '200', 'User found' do
                schema type: :object,
                        properties: {
                        id: { type: :integer },
                        username: { type: :string },
                        email: { type: :string },
                        gender: { type: :string },
                        date_of_birth: { type: :string, format: :date },
                        created_at: { type: :string, format: :date_time }
                        },
                        required: [ 'id', 'username', 'email', 'gender', 'created_at' ]
        
                let(:Authorization) { "Bearer <token>" }
                run_test!
            end

            response '401', 'You need to sign in or sign up before continuing.' do
                let(:Authorization) { " " }
            end
        end
    end
  
    path '/api/v1/logout' do
      delete 'Logs out the current user' do
            tags 'Users'
            produces 'application/json'
            security [Bearer: {}]
    
            response '200', 'Logged out successfully' do
                let(:Authorization) { "Bearer <token>" }
                run_test!
            end

            response '401', "Couldn't find an active session." do
                let(:Authorization) { " " }
            end
      end
    end
  
    path '/api/v1/login' do
      post 'Logs in a user' do
            tags 'Users'
            consumes 'application/json'
            parameter name: :user, in: :body, schema: {
            type: :object,
            properties: {
                email: { type: :string },
                password: { type: :string }
            },
            required: ['email', 'password']
            }
    
            response '200', 'Logged in successfully' do
                let(:user) { { email: 'test@example.com', password: 'password' } }
                run_test!
            end

            response '401', "Invalid email or password" do
                let(:user) { { email: 'test@example.com', password: 'wrongpassword' } }
                run_test!
            end
      end
    end
end
