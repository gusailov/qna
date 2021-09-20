require 'rails_helper'

shared_examples_for 'lists of links, comments, files' do
  it 'contains list of links' do
    expect(resp['links'].size).to eq 5
  end

  it 'contains list of comments' do
    expect(resp['comments'].size).to eq 5
  end

  it 'contains list of files' do
    expect(resp['files'].size).to eq 1
  end
end