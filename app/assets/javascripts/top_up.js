//= require utils
//= require jquery.tmpl.min
//= require jQuery.peSlider
//=require accounting.min
//= require spine/spine
//= require controller/tab
//= require controller/contacts
//= require_self


jQuery(function($){
    window.TopUp = Spine.Controller.create({
        elements:{
            "#quickTopUp":"quickTopUpEl",
            "#groupTopUp":"groupTopUpEl",
            ".progressState":"progressStateEl"
        },

        events:{

        },

        proxied:[],

        init: function(){
            this.quickTopUp=QuickTopUp.init({el:this.quickTopUpEl})
            //this.groupTopUp=GroupTopUp.init({el:this.groupTopUpEl})
            //this.tabController=TabController.init({el:this.el,options:{activeTabClass:"active",activePanelClass:"active"}})

        }
    })

})

jQuery(function($){
    window.QuickTopUp = Spine.Controller.create({
        elements:{
            ".top-up-wrap":"formWrap",
            ".progressState":"progressStateEl",
            "#transferForm":"transferForm",
            "#topUpOrderModal":"topUpOrderModal",
            ".phone_number":"phoneNumberBtn",
            ".contact":"contactBtn"
        },

        events:{
            "click .phone_number":"showPhoneNumber",
            "click .contact":"pickContact"
        },

        proxied:["pay","checkPayValue","onSelected","newTopUp","getNewTopUForm","showTopUpOrder"],

        init: function(){
            this.App.bind("contacts:selection",this.onSelected)
            this.App.bind("contact:new",this.getNewTopUForm)
            $("#quickTopUp").bind("top_up:new",this.newTopUp)
            $("#quickTopUp").bind("top_up:order",this.showTopUpOrder)
            this.contactPicker=ContactPicker.init({el:$("#contactPicker")})
            this.quickTransfeHandler=QuickTransfeHandler.init({el:this.transferForm,contactPicker:this.contactPicker})
            this.show();
        } ,
        show:function(){
            this.phoneNumberBtn.click()
        },
        showTopUpOrder:function(ev,item){
            console.log("item",item.el)
        this.topUpOrderModal.html(item.el);
        this.topUpOrder=TopUpOrder.init({el:this.topUpOrderModal})
        },
        onSelected:function(contact){
            var data={"contact_id":contact.id}
            this.getNewTopUForm(this.contactBtn.attr("href"),data)
        },
        getNewTopUForm:function(url,data){
            this.showProgress()
            $.ajax({
                type: "Get",
                url: url+".js",
                data:data,
                error:this.proxy(function(data){
                    this.hideProgress()
                    this.showError({message:"Sorry an error occurred"})
                }),
                success:this.proxy(function(data){
                    this.hideProgress()
                })
            })
        },
        newTopUp:function(ev,item){
            this.formWrap.html(item.el)
            this.transferForm=this.formWrap.find("#transferForm")
            this.quickTransfeHandler=QuickTransfeHandler.init({el:this.transferForm,contactPicker:this.contactPicker})
        },
        showProgress:function(){
            this.formWrap.html(this.templateProgress())
            //this.progressStateEl.html(this.templateProgress())
        },
        showError:function(msg){
            this.formWrap.html(this.templateError(msg))
            //this.progressStateEl.html(this.templateError(msg))
        },
        hideProgress:function(){
            this.progressStateEl.empty()
        },
        templateProgress:function(){
            return $("#progress-tmpl").tmpl()
        },
        templateError:function(msg){
            return $("#error-tmpl").tmpl(msg)
        },
        showPhoneNumber:function(ev){
            var url=$(ev.currentTarget).attr("href")
            this.getNewTopUForm(url)
            return false;
        },
        pickContact:function(ev){
            var url=$(ev.currentTarget).data("contacts-url")
            this.contactPicker.show(url);
            return false;
        }
    })

})
jQuery(function($){
    window.QuickTransfeHandler = Spine.Controller.create({
        elements:{
            '.networkChoice':"networkChoice",
            ".amountSelect":"amountChoice",
            ".payment":"payment",
            "#slider-range-min":"input",
            ".selectMenu":"selectMenu",
            "#amount":"amount",
            ".pay":"payButton",
            ".tool-bar":"tooBarEl",
            ".phoneNumberInput":"phoneNumberInput",
            ".user-control":"userControl",
            ".phone-control":"phoneControl",
            ".tabbed-control":"tabbedControl",
            ".message-count":"messageCount",
            ".message-area .message":"message",
            ".message-area":"messageWrap"
        },

        events:{
            "change #slider-range-min":"checkPayValue",
            "click .pay":"pay",
            "click .phone":"showPhone",
            "click .contactPicker":"pickContact",
            "keydown .message-area .message":"checkMessage",
            "keyup .message-area .message":"checkMessage"
        },

        proxied:["pay","checkPayValue"],

        init: function(){
            console.log("chosen quickTopUp")
            this.networkChoice.selectmenu();
            this.initElements();
            this.render();
            this.maxCharLen=160
        } ,
        templateUser: function(user){
           // return $("#user-control-tmpl").tmpl(user)
        },
        initElements:function(){
            this.input.peSlider({range: 'min',step:"500"});
            this.selectMenu.selectmenu();
            this.amountChoice.chosen();
            this.payment.selectmenu();
            this.el.submit(this.pay)
            this.input.on("change",this.checkPayValue);
            var inVal = parseFloat(this.input.val());
            this.discount=0.05;
            //this.renderPay(inVal,this.discount)
            this.renderToolButtons();
        },
        checkPayValue:function(){
            var inVal = parseFloat(this.input.val());
            if( !isNaN(inVal) ){
                if(this.payButton.hasClass("disabled")){
                    this.payButton.removeClass("disabled")
                }
                this.renderPay(inVal,0.05)
            }else{
                this.payButton.addClass("disabled")
            }
        },
        pay:function(){
            if(this.payButton.hasClass("disabled")){
                return;
            }
            var url=this.el.attr('action');
            var data=this.el.serialize()
            $.ajax({
                type: "POST",
                url: url+".js",
                data:data,
                success:this.proxy(function(){
                    this.payButton.button('reset')
                })
            })
            this.payButton.button('loading')
            return false;
        },
        renderPay:function(inval,discount){
            inval= inval*(1-discount);
            this.payButton.html('<i class="icon-diary"></i> You Pay : '+accounting.formatMoney(inval, "₦ ", 0))
        },
        render:function(){
            this.show();
        },
        show:function(){
            this.hideAllControls();
            this.phoneControl.show();
            this.el.show();
        },
        hideAllControls:function(){
            this.phoneControl.hide();
            this.userControl.hide();
        },
        checkMessage:function(e){
            console.log("event",this.message.val())
            if(!this.message.val()==""){
                var charLen=this.message.val().length
                var rem=this.maxCharLen-charLen
                if(rem<0){
                   this.messageWrap.addClass("error")
                    this.messageCount.removeClass("badge-success").addClass("badge-important")
                    this.messageCount.html(rem)
                }else{
                    this.messageWrap.removeClass("error")
                    this.messageCount.removeClass("badge-error").addClass("badge-success")
                    this.messageCount.html(rem)
                }
            }
        },
        renderToolButtons:function(state){
            //this.tooBarEl.html($("#tool-buttons-search-tmpl").tmpl(state))
        },
        showPhone:function(){
            this.App.trigger("contact:new")
            return false;
        }
    })

})

jQuery(function($){
    window.TopUpOrder = Spine.Controller.create({
        elements:{
            ".confirm":"confirmButton",
            ".cancel":"cancelButton",
            "#pay-form":"payForm"
        },

        events:{
            "change #slider-range-min":"checkPayValue",
            "click .confirm":"confirm",
            "click .cancel":"cancel",
            "click .contactPicker":"pickContact"
        },

        proxied:["pay","checkPayValue"],

        init: function(){
            this.show();
        },
        show:function(){
            this.el.modal();
        },
        renderPay:function(inval){
            var pay= inval
            this.payButton.html('Deposit : '+accounting.formatMoney(pay, "₦ ", 0))
        },
        cancel:function(){
            if(this.cancelButton.hasClass("disabled")) return false;

            this.cancelButton.button("loading")
            var url=this.cancelButton.attr('href')
            $.ajax({
                type: "POST",
                url: url+".json ",
                error:this.proxy(function(data){
                    this.cancelButton.button("reset")
                }),
                success:this.proxy(function(data){
                    this.el.modal("hide");
                })
            })
            return false;
        },
        confirm:function(){
            if(this.confirmButton.hasClass("disabled")) return false;

            this.confirmButton.button("loading")
            var url=this.confirmButton.data('confirm-url')
            $.ajax({
                type: "POST",
                url: url+".json ",
                error:this.proxy(function(data){
                    this.confirmButton.button("reset")
                }),
                success:this.proxy(function(data){
                    this.payForm.submit()
                })
            })
            return false;
        }
    })

})

jQuery(function($){
    window.GroupTopUp = Spine.Controller.create({
        elements:{
            ".amountSelectGroup":"amountBox"
        },

        events:{

        },

        proxied:[],

        init: function(){
            this.amountBox.chosen();
        }
    })

})

jQuery(function($){
    window.Application = Spine.Controller.create({
        elements:{
          '#topUp':'topUpEl',
          "#quickTopUp":"quickTopUp",
          "#groupTopUp":"groupTopUp",
           ".amountSelect":"amountSelect"
        },

        events:{

        },

        proxied:['updateUI'],

        init: function(){
            this.topUp=TopUp.init({el:this.topUpEl})
            this.amountSelect.chosen();
            console.log("App")
        }
    })

    Application.init({
        el:$("body")
    })
})




