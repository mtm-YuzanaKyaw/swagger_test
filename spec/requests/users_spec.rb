require 'swagger_helper'

RSpec.describe 'users', type: :request do
  let(:valid_attributes) { { email: 'test@example.com', password: 'password123', password_confirmation: 'password123', name: "test" } }
  let(:login_valid_attributes) { { email: 'test@example.com', password: 'password123' } }
  let(:invalid_attributes) { { email: 'invalid_email', password: 'password123', password_confirmation: 'password123' } }
  let(:user) { FactoryBot.create(:user) }
  let(:valid_jwt_token) { generate_jwt(user) }
  let(:valid_token) { generate_jwt(user) } 
  let(:invalid_token) { 'invalid.jwt.token' }

  path '/signup' do

    post('signup users') do
      tags 'Resource'
      consumes 'application/json'
      parameter name: 'user', in: :body, required: true, schema:{
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
              name: { type: :string }
            }
          }
        },
        required: %[ email password name ]
      }
      response(200, 'Sign up successfully!') do

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/login' do
    post('login user') do
      tags 'Resource'
      consumes 'application/json'
      parameter name: 'user', in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string }
            }
          }
        },
        required: %w[ email password ]
      }

      response(200, "Logged in successfully!"){
        after do |example|
          example.metadata[:response][:content] = {
            "application.json" => {
              example: JSON.prase(response.body)
            }
          }
        end
        run_test!
      }
    end
  end

  path '/logout' do
    delete('logout') do
      response(200, "Logout successfully!") do
        let(:Authorization) { "Bearer #{valid_jwt_token}" } 
        after do |example|
          example.metadata['response']['content'] = {
            'application_json' => {
              example: JSON.parse(response.body)
            }
          }
        end
        run_test!
      end
    end
  end
end
