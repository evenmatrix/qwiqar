//= require utils
//= require jquery.tmpl.min
//= require spine/spine
//= require controller/tab
//= require controller/contacts
//= require_self
jQuery(function($){
    window.History = Spine.Controller.create({
        elements:{
            "#orderHistory":"transferHistory",
            "#transferHistory":"transferHistory",
            "#depositHistory":"depositHistory",
            "#historyTabs a:first":"activeTab"
        },

        events:{

        },

        proxied:[],

        init: function(){
            this.contacts = Contacts.init({el:this.allContacts})
            this.groups = Groups.init({el:this.groupContacts})
            this.tabController=TabController.init({el:this.el,options:{activeTabClass:"active",activePanelClass:"active"}})
        }
    })

})

jQuery(function($){
    Spine.Controller.prototype.App.activate=function(controller){
        this.current=controller;
        console.log("activate",this.current)
    },
        Spine.Controller.prototype.App.deactivate=function(controller){
            this.previous=controller;
        }
    window.Application = Spine.Controller.create({
        elements:{
            "#history":"history"
        },

        events:{

        },

        proxied:['updateUI'],

        init: function(){
            this.history=History.init({el:this.history})
        }
    })

    Application.init({
        el:$("body")
    })
})
