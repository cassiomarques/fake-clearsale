# encoding: utf-8
require 'spec_helper'

describe FakeClearsale::App do
  context "Authorize method" do
    let(:order_id) { "12345678" }
    let(:body) { Nokogiri::XML last_response.body }

    after { FakeClearsale::App.clear_requests }

    def do_post(card_number)
      post FakeClearsale::AUTHORIZE_URI, :order_id => order_id, :card_number => card_number
    end

    def returned_status
      body.css("status").text
    end

    def returned_order_id
      body.css("transactionId").text
    end

    context "when authorized" do
      let(:card_number) { FakeClearsale::CreditCards::AUTHORIZE_OK }

      it "adds the received credit card and order id to the list of received requests" do
        do_post card_number
        FakeClearsale::App.received_requests.should == {order_id => FakeClearsale::CreditCards::AUTHORIZE_OK}
      end

      it "returns an XML with the sent order id" do
        do_post card_number
        returned_order_id.should == order_id
      end

      it "returns an XML with the success status code" do
        do_post card_number
        returned_status.should == FakeClearsale::Authorize::Status::AUTHORIZED
      end
    end

    context "when denied" do
      let(:card_number) { FakeClearsale::CreditCards::AUTHORIZE_DENIED }

      it "does not add the received credit card and order id to the list of received requests" do
        do_post card_number
        FakeClearsale::App.received_requests.should == {}
      end      

      it "returns an XML with the sent order id" do
        do_post card_number
        returned_order_id.should == order_id
      end

      it "returns an XML with the denied status code" do
        do_post card_number
        returned_status.should == FakeClearsale::Authorize::Status::DENIED
      end
    end

    context "with capture in the same request" do
      context "when confirmed" do
        let(:card_number) { FakeClearsale::CreditCards::AUTHORIZE_AND_CAPTURE_OK }

        it "does not add the received credit card and order id to the list of received requests" do
          do_post card_number
          FakeClearsale::App.received_requests.should == {}
        end

        it "returns an XML with the sent order id" do
          do_post card_number
          returned_order_id.should == order_id
        end

        it "returns an XML with the captured status code" do
          do_post card_number
          returned_status.should == FakeClearsale::Capture::Status::CAPTURED
        end
      end

      context "denied" do
        let(:card_number) { FakeClearsale::CreditCards::AUTHORIZE_AND_CAPTURE_DENIED }

        it "does not add the received credit card and order id to the list of received requests" do
          do_post card_number
          FakeClearsale::App.received_requests.should == {}
        end

        it "returns an XML with the sent order id" do
          do_post card_number
          returned_order_id.should == order_id
        end

        it "returns an XML with the captured status code" do
          do_post card_number
          returned_status.should == FakeClearsale::Capture::Status::DENIED
        end
      end      
    end
  end

  context "Capture method" do
    context "when authorized" do
      
    end

    context "when denied" do
      
    end
  end
end
