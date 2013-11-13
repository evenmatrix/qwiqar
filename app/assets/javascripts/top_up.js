//= require utils
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




