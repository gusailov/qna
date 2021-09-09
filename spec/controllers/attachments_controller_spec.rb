require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, :attached, user: user) }
  let!(:attachment) { question.files.first }

  describe 'DELETE #destroy' do
    before { login(user) }

    it 'deletes the attachment' do
      expect {
        delete :destroy, params: { id: attachment }, format: :js
      }.to change(ActiveStorage::Attachment, :count).by(-1)
    end

    it 'renders delete view' do
      delete :destroy, params: { id: attachment }, format: :js
      expect(response).to render_template :destroy
    end
  end
end
