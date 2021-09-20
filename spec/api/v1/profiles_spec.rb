require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user, admin: true) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before {
        get api_path, params: { access_token: access_token.token }, headers: headers
      }

      it_behaves_like 'status 200'

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/' do
    let(:api_path) { '/api/v1/profiles/' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end
    context 'authorized' do
      let!(:users) { create_list(:user, 4) }
      let(:access_token) { create(:access_token, resource_owner_id: users.first.id) }
      let(:profile_response) { json['users'].last }

      before {
        get api_path, params: { access_token: access_token.token }, headers: headers
      }

      it_behaves_like 'status 200'

      it 'returns all public fields' do
        %w[id email].each do |attr|
          expect(profile_response[attr]).to eq users.last.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end

      it 'does not return authenticated user' do
        json['users'].each do |user|
          expect(user['id']).to_not eq users.first.id
        end
      end
    end
  end
end
