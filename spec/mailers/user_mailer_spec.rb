require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  before do
    @user = create(:user)
    @user.reset_token = User.new_token
  end

  describe "account_activation" do
    let(:mail) { UserMailer.account_activation(@user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Account activation")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).not_to be_blank
    end
  end

  describe "password_reset" do
    let(:mail) { UserMailer.password_reset(@user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "sends a reset token" do
      assert_match @user.reset_token, mail.body.encoded
      assert_match CGI.escape(@user.email), mail.body.encoded
    end
  end

end
