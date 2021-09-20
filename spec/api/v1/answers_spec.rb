require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 3, user: user, question: question) }

      before {
        get api_path, params: { access_token: access_token.token },
            headers: headers
      }

      it_behaves_like 'status 200'

      it 'returns list of question answers' do
        expect(json['answers'].size).to eq 3
      end
    end
  end
  describe 'GET /api/v1/answers/:id' do

    let!(:answer) { create(:answer, :attached, question: question, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end
    context 'authorized' do
      let(:answer_response) { json['answer'] }
      let!(:comments) { create_list(:comment, 5, commentable: answer) }
      let!(:links) { create_list(:link, 5, linkable: answer) }

      before {
        get api_path, params: { access_token: access_token.token },
            headers: headers
      }

      it_behaves_like 'status 200'

      it_behaves_like 'lists of links, comments, files' do
        let(:resp) { answer_response }
      end
    end
  end
  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end
    context 'authorized' do
      before {
        post api_path, params: { answer: attributes_for(:answer), access_token: access_token.token },
             headers: headers
      }

      it_behaves_like 'status 200'

      it 'create answer' do
        expect { post api_path, params: { answer: attributes_for(:answer), access_token: access_token.token },
                      headers: headers }.to change(Answer, :count).by(1)
      end
    end
  end
  describe 'PATCH /api/v1/answers/:id' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end
    context 'authorized' do
      before {
        patch api_path, params: { answer: { body: 'new body' },
                                  access_token: access_token.token },
              headers: headers
      }

      it_behaves_like 'status 200'

      it 'update question' do
        answer.reload
        expect(answer.body).to eq 'new body'
      end
    end
  end
  describe 'DELETE /api/v1/answers/:id' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

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
                        headers: headers }.to change(Answer, :count).by(-1)
      end
    end

  end
end