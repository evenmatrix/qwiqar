//= require utils
//= require jQuery.peSlider
//=require accounting.min
//= require jquery.tmpl.min
//= require jquery.ui.slider
//= require spine/spine
//= require controller/tab
//= require_self


jQuery(function($){
    window.TopUp = Spine.Controller.create({
        elements:{
            "#quickTopUp":"quickTopUpEl",
            "#groupTopUp":"groupTopUpEl",
            '.networkChoice':"networkChoice"
        },

        events:{

        },

        proxied:[],

        init: function(){
            //this.quickTopUp=QuickTopUp.init({el:this.quickTopUpEl})
            //this.groupTopUp=GroupTopUp.init({el:this.groupTopUpEl})
            //this.tabController=TabController.init({el:this.el,options:{activeTabClass:"active",activePanelClass:"active"}})
            this.networkChoice.selectmenu();
        }
    })

})

jQuery(function($){
    window.QuickTopUp = Spine.Controller.create({
        elements:{
            "#phoneNumberSelect":"phoneChoice",
            "#amountSelect":"amountChoice"
        },

        events:{

        },

        proxied:[],

        init: function(){
            console.log("chosen quickTopUp")
        }
    })

})

jQuery(function($){
    window.Deposit = Spine.Controller.create({
        elements:{
            "#slider-range-min":"input",
            ".selectMenu":"selectMenu",
            "#amount":"amount",
            ".pay":"payButton"
        },

        events:{
           "change #slider-range-min":"checkPayValue",
            "click .pay":"pay",
            "click .contactPicker":"pickContact"
        },

        proxied:["pay","checkPayValue"],

        init: function(){
            this.initElements();
            this.show();
        },
        initElements:function(){
            this.input.peSlider({range: 'min',step:"5000"});
            this.selectMenu.selectmenu();
            this.input.on("change",this.checkPayValue);
            var inVal = parseFloat(this.input.val());
            this.renderPay(inVal)
        },
        checkPayValue:function(){
            var inVal = parseFloat(this.input.val());
            if( !isNaN(inVal) ){
                if(this.payButton.hasClass("disabled")){
                    this.payButton.removeClass("disabled")
                }
                this.renderPay(inVal)
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
                success:this.success
            })
            this.payButton.button('loading')
            return false;
        },
        failure:function(){

        },
        show:function(){
            this.el.show();
        },
        renderPay:function(inval){
             var pay= inval
             this.payButton.html('Deposit : '+accounting.formatMoney(pay, "₦ ", 0))
        }
    })

})

jQuery(function($){
    window.DepositOrder = Spine.Controller.create({
        elements:{
            ".pay":"payButton",
            ".cancel":"cancelButton",
            "#pay-form":"payForm"
        },

        events:{
            "change #slider-range-min":"checkPayValue",
            "click .pay":"pay",
            "click .cancel":"cancel",
            "click .contactPicker":"pickContact"
        },

        proxied:["pay","checkPayValue"],

        init: function(){
            this.show();
        },
        initElements:function(){
            this.input.peSlider({range: 'min',step:"5000"});
            this.el.submit(this.pay)
            this.selectMenu.selectmenu();
            this.input.on("change",this.checkPayValue);
            var inVal = parseFloat(this.input.val());
            this.renderPay(inVal)
        },
        checkPayValue:function(){
            var inVal = parseFloat(this.input.val());
            if( !isNaN(inVal) ){
                if(this.payButton.hasClass("disabled")){
                    this.payButton.removeClass("disabled")
                }
                this.renderPay(inVal)
            }else{
                this.payButton.addClass("disabled")
            }
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
        pay:function(){
            if(this.payButton.hasClass("disabled")) return false;

            this.payButton.button("loading")
            var gateway=this.payButton.data('payment-method')
            console.log("gateway",gateway)
            switch(gateway){
                case "interswitch":
                    this.payForm.submit();
                    break;
                case "wallet":
                    data=this.payForm.serialize();
                    url=this.payForm.attr("action")
                    $.ajax({
                        type: "POST",
                        url: url+".js",
                        data:data,
                        error:this.proxy(function(data){
                            this.payButton.button("reset")
                        }),
                        success:this.proxy(function(data){

                        })
                    })
                    break;
            }
            return false;
        }
    })

})

jQuery(function($){
    window.Application = Spine.Controller.create({
        elements:{
            '#deposit-form':'depositEl',
            ".wallet-wrap":"walletEl",
            "#depositOrderModal":"orderModal"
        },

        events:{

        },

        proxied:['showNewDeposit','showDepositOrder'],

        init: function(){
            $('#wallet').bind("deposit:new",this.showNewDeposit)
            $('#wallet').bind("deposit:order",this.showDepositOrder)
            this.deposit=Deposit.init({el:this.depositEl})
            console.log("App")
        },

        showNewDeposit:function(ev,item){
        this.walletEl.html(item.el);
        this.depositEl=this.walletEl.find("#deposit-form")
        this.deposit=Deposit.init({el:this.depositEl})
        },
        showDepositOrder:function(ev,item){
            this.orderModal.html(item.el);
            this.depositOrder=DepositOrder.init({el:this.orderModal})
        }
    })

    Application.init({
        el:$("body")
    })
})




