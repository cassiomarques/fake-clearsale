# encoding: utf-8
require 'spec_helper'

describe FakeClearsale::App do
  describe "POST SendOrders" do
    it "should respond approved as status" do
      post "/SendOrders", {
        :xml => make_clearsale_xml("Fulano Confiavel", "1234")
      }

      last_response.body.should == <<-EOF
<?xml version="1.0" encoding="utf-8"?>
<string xmlns="http://www.clearsale.com.br/integration">&lt;?xml version="1.0" encoding="utf-16"?&gt;
&lt;PackageStatus&gt;
  &lt;TransactionID&gt;1234&lt;/TransactionID&gt;
  &lt;StatusCode&gt;00&lt;/StatusCode&gt;
  &lt;Message&gt;OK&lt;/Message&gt;
  &lt;Orders&gt;
    &lt;Order&gt;
      &lt;ID&gt;1234&lt;/ID&gt;
      &lt;Status&gt;APA&lt;/Status&gt;
      &lt;Score&gt;95.9800&lt;/Score&gt;
    &lt;/Order&gt;
  &lt;/Orders&gt;
&lt;/PackageStatus&gt;</string>
      EOF
    end

    it "should respond reproved as status" do
      post "/SendOrders", {
        :xml => make_clearsale_xml("Fulano Estranho", "123iohqskjs4")
      }

      last_response.body.should == <<-EOF
<?xml version="1.0" encoding="utf-8"?>
<string xmlns="http://www.clearsale.com.br/integration">&lt;?xml version="1.0" encoding="utf-16"?&gt;
&lt;PackageStatus&gt;
  &lt;TransactionID&gt;123iohqskjs4&lt;/TransactionID&gt;
  &lt;StatusCode&gt;00&lt;/StatusCode&gt;
  &lt;Message&gt;OK&lt;/Message&gt;
  &lt;Orders&gt;
    &lt;Order&gt;
      &lt;ID&gt;123iohqskjs4&lt;/ID&gt;
      &lt;Status&gt;RPA&lt;/Status&gt;
      &lt;Score&gt;40.9320&lt;/Score&gt;
    &lt;/Order&gt;
  &lt;/Orders&gt;
&lt;/PackageStatus&gt;</string>
      EOF
    end
  end

  describe "POST GetOrderStatus" do
    it "should respond approved as status" do
      post "/SendOrders", {
        :xml => make_clearsale_xml("Fulano Confiavel", "lalala")
      }

      post "/GetOrderStatus", { :orderID => "lalala" }

      last_response.body.should == <<-EOF
<?xml version="1.0" encoding="utf-8"?>
<string xmlns="http://www.clearsale.com.br/integration">&lt;?xml version="1.0" encoding="utf-16"?&gt;
&lt;ClearSale&gt;
  &lt;Orders&gt;
    &lt;Order&gt;
      &lt;ID&gt;lalala&lt;/ID&gt;
      &lt;Status&gt;APA&lt;/Status&gt;
      &lt;Score&gt;95.9800&lt;/Score&gt;
    &lt;/Order&gt;
  &lt;/Orders&gt;
&lt;/ClearSale&gt;</string>
      EOF
    end

    it "should respond reproved as status" do
      post "/SendOrders", {
        :xml => make_clearsale_xml("Fulano Estranho", "LOL")
      }

      post "/GetOrderStatus", { :orderID => "LOL" }

      last_response.body.should == <<-EOF
<?xml version="1.0" encoding="utf-8"?>
<string xmlns="http://www.clearsale.com.br/integration">&lt;?xml version="1.0" encoding="utf-16"?&gt;
&lt;ClearSale&gt;
  &lt;Orders&gt;
    &lt;Order&gt;
      &lt;ID&gt;LOL&lt;/ID&gt;
      &lt;Status&gt;RPA&lt;/Status&gt;
      &lt;Score&gt;40.9320&lt;/Score&gt;
    &lt;/Order&gt;
  &lt;/Orders&gt;
&lt;/ClearSale&gt;</string>
      EOF
    end
  end

  describe "POST GetAnalystComments" do
    it "should respond with some comments" do
      post "/GetAnalystComments", :orderID => "meuorderid"

      last_response.body.should == <<-EOF
<?xml version="1.0" encoding="utf-8"?>
<string xmlns="http://www.clearsale.com.br/integration">&lt;?xml version="1.0" encoding="utf-16"?&gt;
&lt;Order&gt;
  &lt;ID&gt;meuorderid&lt;/ID&gt;
  &lt;Date d2p1:nil="true" xmlns:d2p1="http://www.w3.org/2001/XMLSchema-instance" /&gt;
  &lt;QtyInstallments d2p1:nil="true" xmlns:d2p1="http://www.w3.org/2001/XMLSchema-instance" /&gt;
  &lt;ShippingPrice d2p1:nil="true" xmlns:d2p1="http://www.w3.org/2001/XMLSchema-instance" /&gt;
  &lt;ShippingTypeID&gt;0&lt;/ShippingTypeID&gt;
  &lt;ManualOrder&gt;
    &lt;ManualQuery d3p1:nil="true" xmlns:d3p1="http://www.w3.org/2001/XMLSchema-instance" /&gt;
    &lt;UserID&gt;0&lt;/UserID&gt;
  &lt;/ManualOrder&gt;
  &lt;TotalItens&gt;0&lt;/TotalItens&gt;
  &lt;TotalOrder&gt;0&lt;/TotalOrder&gt;
  &lt;Gift&gt;0&lt;/Gift&gt;
  &lt;Status&gt;-1&lt;/Status&gt;
  &lt;Reanalise&gt;0&lt;/Reanalise&gt;
  &lt;WeddingList d2p1:nil="true" xmlns:d2p1="http://www.w3.org/2001/XMLSchema-instance" /&gt;
  &lt;ReservationDate d2p1:nil="true" xmlns:d2p1="http://www.w3.org/2001/XMLSchema-instance" /&gt;
  &lt;ShippingData&gt;
    &lt;Type d3p1:nil="true" xmlns:d3p1="http://www.w3.org/2001/XMLSchema-instance" /&gt;
    &lt;BirthDate d3p1:nil="true" xmlns:d3p1="http://www.w3.org/2001/XMLSchema-instance" /&gt;
    &lt;Phones /&gt;
    &lt;Address /&gt;
  &lt;/ShippingData&gt;
  &lt;CollectionData&gt;
    &lt;Type d3p1:nil="true" xmlns:d3p1="http://www.w3.org/2001/XMLSchema-instance" /&gt;
    &lt;BirthDate d3p1:nil="true" xmlns:d3p1="http://www.w3.org/2001/XMLSchema-instance" /&gt;
    &lt;Phones /&gt;
    &lt;Address /&gt;
  &lt;/CollectionData&gt;
  &lt;Payments /&gt;
  &lt;Items /&gt;
  &lt;Passangers /&gt;
  &lt;Connections /&gt;
  &lt;AnalystComments&gt;
    &lt;AnalystComments&gt;
      &lt;CreateDate&gt;2011-12-06T18:04:54.033&lt;/CreateDate&gt;
      &lt;Comments&gt;outro teste de observacao&lt;/Comments&gt;
      &lt;UserName /&gt;
      &lt;Status&gt;RPM&lt;/Status&gt;
      &lt;LineName&gt;FILA GERAL&lt;/LineName&gt;
    &lt;/AnalystComments&gt;
    &lt;AnalystComments&gt;
      &lt;CreateDate&gt;2011-12-06T18:04:37.723&lt;/CreateDate&gt;
      &lt;Comments&gt;teste de observacao&lt;/Comments&gt;
      &lt;UserName /&gt;
      &lt;Status&gt;RPM&lt;/Status&gt;
      &lt;LineName&gt;FILA GERAL&lt;/LineName&gt;
    &lt;/AnalystComments&gt;
  &lt;/AnalystComments&gt;
&lt;/Order&gt;</string>
      EOF
    end
  end
end
