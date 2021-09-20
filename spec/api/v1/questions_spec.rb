require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, user: user, question: question) }

      before {
        get api_path, params: { access_token: access_token.token },
            headers: headers
      }

      it_behaves_like 'status 200'

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question, :attached, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:question_response) { json['question'] }
      let!(:comments) { create_list(:comment, 5, commentable: question) }
      let!(:links) { create_list(:link, 5, linkable: question) }
      let!(:answers) { create_list(:answer, 3, user: user, question: question) }

      before {
        get api_path, params: { access_token: access_token.token },
            headers: headers
      }

      it_behaves_like 'status 200'

      it_behaves_like 'lists of links, comments, files' do
        let(:resp) { question_response }
      end
    
      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end
    end
  end

  describe 'POST /api/v1/questions/' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end
    context 'authorized' do
      before {
        post api_path, params: { question: attributes_for(:question), access_token: access_token.token },
             headers: headers
      }

      it_behaves_like 'status 200'

      it 'create question' do
        expect { post api_path, params: { question: attributes_for(:question), access_token: access_token.token },
                      headers: headers }.to change(Question, :count).by(1)
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end
    context 'authorized' do
      before {
        patch api_path, params: { question: { title: 'new title', body: 'new body' },
                                  access_token: access_token.token },
              headers: headers
      }

      it_behaves_like 'status 200'

      it 'update question' do
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end
    end
  end
  describe 'DELETE /api/v1/questions/:id' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end
    context 'authorized' do

      it 'returns 200 status' do
        delete api_path, params: { access_token: access_token.token }, headers: headers
        expect(response).to be_successful
      end

      it 'delete question' do
        expect { delete api_path, params: { access_token: access_token.token },
                        headers: headers }.to change(Question, :count).by(-1)
      end
    end

  end
end
