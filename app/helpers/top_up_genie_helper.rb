module TopUpGenieHelper
  API_KEY=""
  SECRET=""
  TOKEN=""



  def query_top_up_status(top_up)
  url="https://topupgenie.com/beta/vas/merchants/querytopupstatus.json"
  params={:key=>API_KEY,:secret=>SECRET,:order_id=>top_up.top_genie_order_id}
  response=RestClient.get url,:params => params
  case response.code
    when 200
      result=Yajl::Parser.parse(response)
      status=result["status"]
      data=result["data"]
      if status = "01"
        top_up_genie_order=data["order"]
        case top_up_genie_order["orderstatus"]
          when "1"
            top_up.on_top_up_delivered top_up_genie_order
          else
            #log failure error / what exactly happened to top_up genie
            #top_up.on_top_failed
        end
      end
    else
      response.return!(request,result,&block)
  end
  end

  def top_up_balance
    url="https://topupgenie.com/beta/vas/merchants/getbalance.json"
    params={:key=>API_KEY,:secret=>SECRET}
    response=RestClient.get url,:params => params
    balance=case response.code
      when 200
        result=Yajl::Parser.parse(response)
        status=result["status"]
        data=result["data"]
        if status = "true"
          data["balance"]
        end
      else
        response.return!(request,result,&block)
    end
  end

  def get_number_for_tup_up(top_up)
       phone_number=case top_up.type
         when "PhoneNumberTopUp"
              top_up.phone_number
         when "ContactTopUp"
             top_up.contact.phone_number
      end
  end


  def top_up(top_up)
    balance=top_up_balance
    if balance - top_up.amount > 100000
      do_top_up(top_up)
    else
      #log y/ notify listeners/ drop balance error
      #log d failure error /insufficient system balance
      #top_up.on_top_failed
    end
  end

  private
  def do_top_up(top_up)
    url="https://topupgenie.com/beta/vas/merchants/topup.json"
    phone_number=get_number_for_tup_up(top_up);
    params={:key=>API_KEY,:secret=>SECRET,:amount=>top_up.item.amount,:network=>phone_number.carrier.name.upcase,:number=>phone_number.number}
    response=RestClient.get url,:params => params
    case response.code
      when 200
        result=Yajl::Parser.parse(response)
        status=result["status"]
        data=result["data"]
        if status = "01"
          top_up.save_top_genie_order(data["order"])
          query_top_up_status(top_up)
        else
          #log failure error / what exactly happened to top_up genie
          #top_up.on_top_failed
        end
      else
        response.return!(request,result,&block)
    end
  end

end
