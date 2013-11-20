//= require utils
//= require jQuery.peSlider
//=require accounting.min
//= require jquery.tmpl.min
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
            this.amountChoice.chosen();
            this.phoneChoice.chosen();
        }
    })

})

jQuery(function($){
    window.Wallet = Spine.Controller.create({
        elements:{
            "#slider-range-min":"input",
            ".selectMenu":"selectMenu",
            "#amount":"amount",
            ".pay":"payButton"
        },

        events:{
           "change #slider-range-min":"checkPayValue",
            "click .pay":"pay"
        },

        proxied:["pay","checkPayValue"],

        init: function(){
            this.initElements();
            this.show();
        },
        initElements:function(){
            this.input.peSlider({range: 'min',step:"5000"});
            this.el.submit(this.pay)
            this.selectMenu.selectmenu();
            this.input.on("change",this.checkPayValue);
            var inVal = parseFloat(this.input.val());
            this.percent=3;
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
           // return false;
        },
        show:function(){
            this.el.show();
        },
        renderPay:function(inval){
             var pay= inval*(1-(this.percent/100))
            this.payButton.html('Pay : '+accounting.formatMoney(pay, "₦ ", 0))
        }
    })

})

jQuery(function($){
    window.Application = Spine.Controller.create({
        elements:{
            '#wallet-form':'walletEl'
        },

        events:{

        },

        proxied:['updateUI'],

        init: function(){
            this.waller=Wallet.init({el:this.walletEl})
            this.amountSelect.chosen();
            console.log("App")
        }
    })

    Application.init({
        el:$("body")
    })
})




