require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:valid_attributes) {
  	{
  		first_name: "Jabba",
  		last_name: "Thehut",
  		email: "jabba@thehut.com",
  		password: "jabba1234",
  		password_confirmation: "jabba1234"
  	}
  }

  context "validations" do
  	let(:user) { User.new(valid_attributes) }
  	
  	before do
  		User.create(valid_attributes)
  	end

  	it "requires an email" do
  		expect(user).to validate_presence_of(:email)
  	end

  	it "requires a unique email" do
  		expect(user).to validate_uniqueness_of(:email)
  	end

  	it "requires a unique email (case insensitive)" do
  		user.email = "JABBA@THEHUT.COM"
  		expect(user).to validate_uniqueness_of(:email)
  	end

  	it "requires the email address to look like an email" do
  		user.email = "jabba"
  		expect(user).to_not be_valid
  	end

  
  end

  describe "#downcase_email" do
  	it "makes the email attribute lower case" do
  		user = User.new(valid_attributes.merge(email: "JABBA@THEHUT.COM") )
  		#user.downcase_email
  		#expect(user.email).to eq("jabba@thehut.com")
  		expect{ user.downcase_email }.to change{ user.email }.
  			from("JABBA@THEHUT.COM").
  			to("jabba@thehut.com")
	end

	it "downcases an email before saving" do
  		user = User.new(valid_attributes)
  		user.email = "JABBA@THEHUT.COM"
  		expect(user.save).to be_truthy
  		expect(user.email).to eq("jabba@thehut.com")
  	end

  end


end
