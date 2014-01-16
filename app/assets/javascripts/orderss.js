//= require utils
//= require jquery.tmpl.min
//= require jQuery.peSlider
//=require accounting.min
//= require bootstrap-datepicker
//= require spine/spine
//= require controller/tab
//= require wallets
//= require_self

jQuery(function($){
    window.OrderController = Spine.Controller.create({
        elements:{
            ".modal-header":"header",
            ".modal-body":"body",
            ".modal-footer":"footer",
            ".pay":"payButton",
            ".requery":"reQueryButton",
            "#pay-form":"payForm"
        },
        events:{
            "click .pay":"pay",
            "click .requery":"requery",
            "click .cancel":"cancel"
        },
        proxied: ["render",'activate','deActivate','success',"show",'failure','getOrderUrl','getOrder'],
        init: function(){
            $('#OrderModal').bind("orders:show",this.show)
            this.App.bind("orders:show",this.getOrder)
            this.App.bind("orders:show:url",this.getOrderUrl)
        },
        template:function(data){
        },
        templateProgress:function(){
            return $("#progress-tmpl").tmpl()
        },
        templateError:function(msg){
            return $("#error-tmpl").tmpl(msg)
        },
        show:function(ev,item){
            console.log("show new order",item)
            this.el.html(item.el)
            this.preRender()
        },
        getOrder:function(order){
            this.order=order
            this.doGetOrder(this.contact.url)
            return false;
        },
        getOrderUrl:function(url){
            console.log("getOrderUrl",url)
            this.url=url;
            this.doGetOrder(this.url)
        },
        doGetOrder:function(url){
            console.log("url",url)
            this.render()
            this.showProgress()
            $.ajax({
                type: "GET",
                url: url+".js",
                success:this.proxy(function(){

                }),
                error:this.failure
            })
        },
        preRender:function(){
            this.header=this.el.find(".modal-header")
            this.body=this.el.find(".modal-body")
            this.footer=this.el.find(".modal-footer")
            this.reQueryButton= this.el.find(".requery")
            this.payButton= this.el.find(".pay")
            this.payForm= this.el.find("#pay-form")
        },
        renderDefault:function(){
            this.el.html($("#default-dialog-tmpl").tmpl())
            this.preRender();
        },
        empty:function(){

        },
        render:function(){
            this.el.modal();
        } ,
        renderHeader:function(){
            this.header.html($("#modal-header-contact-tmpl").tmpl())
        },
        showProgress:function(){
            this.renderDefault()
            this.body.html(this.templateProgress())
        },
        showError:function(msg){
            this.body.html(this.templateError(msg))
        },
        defaultButtons:function(){
            this.buttons.html($("#modal-close-tmpl").tmpl())
        },
        activate:function(){
        },
        deActivate:function(){
            this.el.modal('hide');
        },
        success:function(data){
        },
        failure:function(data){
            console.log("error",data.responseText)
            //eval(data.responseText)
            //this.createButton.addClass("disabled")
            this.renderDefault()
            var error='<strong>Sorry!</strong> an error occured, please try again later'
            this.showError({message:error})
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
        requery:function(){
            if(this.reQueryButton.hasClass("disabled")) return false;

            this.reQueryButton.button("loading")
            var url=this.reQueryButton.attr('href')
            $.ajax({
                type: "GET",
                url: url+".js",
                error:this.proxy(function(data){
                    this.reQueryButton.button("reset")
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
    });
})

jQuery(function($){
    window.TableSearch = Spine.Controller.create({
        elements:{
            "select":"filter",
            ".advanced":"advancedBtn",
            ".advanced-search":"advancedSearchEl",
            ".start_date":"startDateInput",
            ".start_date_btn":"startDateBtn",
            ".end_date":"endDateInput",
            ".end_date_btn":"endDateBtn",
            ".datepicker":"datepicker",
            ".custom-search-input":"searchEl",
            ".custom-search-anchor":"searchOptionBtn"
        },

        events:{
            "change .filter":"filterChange",
            "click .advanced":"toggleAdvancedSearch",
            //"click .search-btn":"query",
            "click .custom-search-anchor":"toggleAdvancedSearch"

        },

        proxied:["query"],

        init: function(){
           this.tabController=TabButtonMenuController.init({el:this.el,options:{activeTabClass:"active",activePanelClass:"active"}})
            this.initElements();
            //this.el.submit(this.query)
        },
        initElements:function(){
            this.filter.selectmenu();
            console.log("filter",this.filter)
            this.datepicker.datepicker()
        },
        toggleAdvancedSearch:function(){
            console.log("toggle")
            if(this.searchEl.hasClass("open")){
                this.searchOptionBtn.html('<i class="icon-caret-down"></i>')
               this.searchEl.removeClass("open")
            }else{
                this.searchOptionBtn.html('<i class="icon-caret-up"></i>')
                this.searchEl.addClass("open")
                //this.datepicker.datepicker()
            }
        },
        filterChange:function(ev){
            console.log("selection change",ev)
        },
        showDate:function(ev){
        },
        query:function(){
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
        }
    })

})

jQuery(function($){
    window.All = Spine.Controller.create({
        elements:{
            "#tableSearch":"tableSearchEl"
        },

        events:{
            "click tr td a":"showOrder"
        },

        proxied:[],

        init: function(){
           console.log("inited All")
           this.tableSearch=TableSearch.init({el:this.tableSearchEl})
        },
        showOrder:function(ev){
            var url=$(ev.currentTarget).attr("href");
            try{
                this.App.trigger("orders:show:url",url);
            }catch(e){
                console.log(e)
            }
            return false;
        }
    })

})

jQuery(function($){
    window.History = Spine.Controller.create({
        elements:{
            "#all":"all",
            "#topUp":"topUp",
            "#deposit":"deposit",
            "#OrderModal":"orderModal"
        },

        events:{
        },

        proxied:[],

        init: function(){
            this.allController = All.init({el:this.all})
            this.tabController=TabController.init({el:this.el,options:{activeTabClass:"active",activePanelClass:"active"}})
            this.orderController=OrderController.init({el:this.orderModal})
        },
        showNewContact:function(ev){
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


