require 'spec_helper'

describe "Pages" do
  subject { page }

  describe "Home page" do
    before { visit root_path }
    it { should have_selector('h1', text: 'Welcome') }
    it { should have_selector('title', text: "Texts4Terps") }
    it { should_not have_selector('title', text: '| Home') }
  end
end
