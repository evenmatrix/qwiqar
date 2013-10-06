//= require utils
//= require jquery.tmpl.min
//= require spine/spine
//= require_self


jQuery(function($){
    window.TopUp = Spine.Controller.create({
        elements:{
            "#quickTopUp":"quickTopUpEl",
            "#groupTopUp":"groupTopUpEl"
        },

        events:{

        },

        proxied:[],

        init: function(){
            this.quickTopUp=QuickTopUp.init({el:this.quickTopUpEl})
            this.groupTopUp=GroupTopUp.init({el:this.groupTopUpEl})
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
    window.GroupTopUp = Spine.Controller.create({
        elements:{
        },

        events:{

        },

        proxied:[],

        init: function(){
            console.log("groupTopUp")
        }
    })

})

jQuery(function($){
    window.Application = Spine.Controller.create({
        elements:{
          '#topUp':'topUpEl',
          "#quickTopUp":"quickTopUp",
          "#groupTopUp":"groupTopUp"
        },

        events:{

        },

        proxied:['updateUI'],

        init: function(){
            this.topUp=TopUp.init({el:this.topUpEl})
            console.log("App")
        }
    })

    Application.init({
        el:$("body")
    })
})




