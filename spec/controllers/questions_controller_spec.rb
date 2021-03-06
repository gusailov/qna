require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted' do
    let(:votable) { create(:question, user: author) }
  end

  it_behaves_like 'commented' do
    let(:commentable) { create(:question, user: author) }
  end

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 5, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it { expect(response).to render_template :index }
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it { expect(assigns(:question)).to eq question }

    it { expect(response).to render_template :show }

    it { expect(assigns(:answer)).to be_a_new(Answer) }
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it { expect(assigns(:question)).to be_a_new(Question) }

    it { expect(response).to render_template :new }
  end

  describe 'POST #create' do
    before { login(user) }

    let(:question) { create(:question, :rewarded, user: user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect {
          post :create, params: { question: attributes_for(:question) }
        }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect {
          post :create, params: { question: attributes_for(:question, :invalid) }
        }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update,
              params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before {
        patch :update,
              params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
      }

      it 'does not change question' do
        question.reload

        expect {}.to_not change(question, :title)
        expect {}.to_not change(question, :body)
      end

      it { expect(response).to render_template :update }
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:question) { create(:question, user: user) }

    it 'deletes the question ' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end
