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
               params: { question_id: question, user_id: user, answer: attributes_for(:answer) },
               format: :js
        }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create,
             params: { question_id: question, user_id: user, answer: attributes_for(:answer) },
             format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect {
          post :create,
               params: { question_id: question, answer: attributes_for(:answer, :invalid) },
               format: :js
        }.to_not change(question.answers, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) },
                      format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end
    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update,
                params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end
      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) },
                       format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #favorite' do
    before { login(user) }

    let(:answer) { create(:answer, question: question, user: user) }

    it 'changes answer attribute favorite' do
      patch :favorite, params: { id: answer }, format: :js

      expect { answer.reload }.to change(answer, :favorite)
    end
    it 'renders favorite view' do
      patch :favorite, params: { id: answer }, format: :js
      expect(response).to render_template :favorite
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:answer) { create(:answer, user: user, question: question) }

    it 'deletes the answer ' do
      expect {
        delete :destroy, params: { id: answer }, format: :js
      }.to change(Answer, :count).by(-1)
    end

    it 'renders destroy view' do
      delete :destroy, params: { id: answer }, format: :js
      expect(response).to render_template :destroy
    end
  end
end
