require 'spec_helper'

module FakeWeb
  class StubSocket
    def read_timeout=(ignored)
    end
  end
end

# Silly enemy unit test to document PaperClip/S3 behavior.
#
#
describe "PaperClip and S3" do

  describe "upload behaviour" do
    describe "for companies" do
      before(:each) do
        FakeWeb.register_uri(:any, 'https://bucket-test.s3.amazonaws.com/companies/logos/1/medium.png', :body => "OK")
        FakeWeb.register_uri(:any, 'https://bucket-test.s3.amazonaws.com/companies/logos/1/original.png', :body => "OK")
        FakeWeb.register_uri(:any, 'https://bucket-test.s3.amazonaws.com/companies/logos/1/thumb.png', :body => "OK")

        @company = FactoryGirl.create(:company, :logo => File.new(Rails.root + 'spec/samples/heart.png'))
      end

      it "should upload files" do
        @company.logo.url(:medium).should =~ Regexp.new("http://s3.amazonaws.com/bucket-test/companies/logos/1/medium.png")
        @company.logo.url(:original).should =~ Regexp.new("http://s3.amazonaws.com/bucket-test/companies/logos/1/original.png")
        @company.logo.url(:thumb).should =~ Regexp.new("http://s3.amazonaws.com/bucket-test/companies/logos/1/thumb.png")
      end
    end

    describe "for groups" do
      before(:each) do
        FakeWeb.register_uri(:any, 'https://bucket-test.s3.amazonaws.com/groups/logos/1/medium.png', :body => "OK")
        FakeWeb.register_uri(:any, 'https://bucket-test.s3.amazonaws.com/groups/logos/1/original.png', :body => "OK")
        FakeWeb.register_uri(:any, 'https://bucket-test.s3.amazonaws.com/groups/logos/1/thumb.png', :body => "OK")

        @group = FactoryGirl.create(:group, :logo => File.new(Rails.root + 'spec/samples/heart.png'))
      end

      it "should upload files" do
        @group.logo.url(:medium).should =~ Regexp.new("http://s3.amazonaws.com/bucket-test/groups/logos/1/medium.png")
        @group.logo.url(:original).should =~ Regexp.new("http://s3.amazonaws.com/bucket-test/groups/logos/1/original.png")
        @group.logo.url(:thumb).should =~ Regexp.new("http://s3.amazonaws.com/bucket-test/groups/logos/1/thumb.png")
      end
    end

    describe "for projects" do
      before(:each) do
        FakeWeb.register_uri(:any, 'https://bucket-test.s3.amazonaws.com/projects/logos/1/medium.png', :body => "OK")
        FakeWeb.register_uri(:any, 'https://bucket-test.s3.amazonaws.com/projects/logos/1/original.png', :body => "OK")
        FakeWeb.register_uri(:any, 'https://bucket-test.s3.amazonaws.com/projects/logos/1/thumb.png', :body => "OK")

        @project = FactoryGirl.create(:project, :logo => File.new(Rails.root + 'spec/samples/heart.png'))
      end

      it "should upload files" do
        @project.logo.url(:medium).should =~ Regexp.new("http://s3.amazonaws.com/bucket-test/projects/logos/1/medium.png")
        @project.logo.url(:original).should =~ Regexp.new("http://s3.amazonaws.com/bucket-test/projects/logos/1/original.png")
        @project.logo.url(:thumb).should =~ Regexp.new("http://s3.amazonaws.com/bucket-test/projects/logos/1/thumb.png")
      end
    end

    # describe "for groups" do
    #   before(:each) do
    #     FakeWeb.register_uri(:any, 'https://bucket-test.s3.amazonaws.com/logos/1/medium.png', :body => "OK")
    #     FakeWeb.register_uri(:any, 'https://bucket-test.s3.amazonaws.com/logos/1/original.png', :body => "OK")
    #     FakeWeb.register_uri(:any, 'https://bucket-test.s3.amazonaws.com/logos/1/thumb.png', :body => "OK")

    #     @group = FactoryGirl.build(:group, :logo => File.new(Rails.root + 'spec/samples/heart.png'))
    #     @group.save!
    #   end

    #   it "should upload files" do
    #     p @group.logo
    #   end
    # end

    # describe "for projects" do

    # end
  end

end