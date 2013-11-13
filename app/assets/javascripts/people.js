//= require utils
//= require jquery.tmpl.min
//= require spine/spine
//= require controller/tab
//= require controller/contacts
//= require_self
jQuery(function($){
    window.Groups = Spine.Controller.create({
        elements:{
            ".items":"itemsEl",
            ".items .item":'handler'
        },

        events:{

        },

        proxied:[""],

        proxied:["show"],

        init: function(){
            this.App.bind("show:groups",this.show)
        },
        show:function(){
            console.log("show:groups")
        }
    })

})

jQuery(function($){
    window.People = Spine.Controller.create({
        elements:{
            "#allContacts":"allContacts",
             "#groupContacts":"groupContacts",
             "#contactTabs":"contactTabs",
             "#contactTabs a:first":"activeTab"
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
            "#people":"people"
        },

        events:{

        },

        proxied:['updateUI'],

        init: function(){
            this.people=People.init({el:this.people})
        }
    })

    Application.init({
        el:$("body")
    })
})
