require "rails_helper"

RSpec.describe SubRequestMailer, type: :mailer do
  describe "request_of_group" do
    let(:mail) { SubRequestMailer.request_of_group }

    it "renders the headers" do
      expect(mail.subject).to eq("Request of group")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "request_of_all" do
    let(:mail) { SubRequestMailer.request_of_all }

    it "renders the headers" do
      expect(mail.subject).to eq("Request of all")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "confirmation" do
    let(:mail) { SubRequestMailer.confirmation }

    it "renders the headers" do
      expect(mail.subject).to eq("Confirmation")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "fulfilled" do
    let(:mail) { SubRequestMailer.fulfilled }

    it "renders the headers" do
      expect(mail.subject).to eq("Fulfilled")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "unfulfilled" do
    let(:mail) { SubRequestMailer.unfulfilled }

    it "renders the headers" do
      expect(mail.subject).to eq("Unfulfilled")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "reminder" do
    let(:mail) { SubRequestMailer.reminder }

    it "renders the headers" do
      expect(mail.subject).to eq("Reminder")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
