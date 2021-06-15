require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect {
          post :create,
               params: { question_id: question, user_id: user, answer: attributes_for(:answer) }
        }.to change(question.answers, :count).by(1)
      end

      it 'redirects to answers question_path' do
        post :create,
             params: { question_id: question, user_id: user, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(assigns(:answer).question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect {
          post :create,
               params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        }.to_not change(question.answers, :count)
      end

      it 're-renders question path' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:answer) { create(:answer, user: user, question: question) }

    it 'deletes the answer ' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to question_path' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question_path(question)
    end
  end
end
