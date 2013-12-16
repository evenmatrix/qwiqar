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
            //this.el.submit(this.pay)
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
        pay:function(){
            if(this.payButton.hasClass("disabled")){
                return;
            }
            // return false;
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
    window.ContactController = Spine.Controller.create({
        elements:{
            ".modal-header .contactHeader":"header",
            ".modal-header .toast":"notice",
            ".modal-body":"body",
            ".modal-footer":"footer",
            ".modal-footer .btns":"buttons"
        },
        events:{
            "click .edit":"edit"
        },
        proxied: ["render",'activate','deActivate','success',"show",'failure','showContactForm','getContactUrl','showEditForm','getDeleteForm','getContact'],
        init: function(){
            $('#newContactDialog').bind("contacts:show",this.show)
            this.App.bind("contacts:show",this.getContact)
            this.App.bind("contacts:show:url",this.getContactUrl)
        },
        template:function(data){
        },
        templateProgress:function(){
            return $("#modal-progress-tmpl").tmpl()
        },
        templateError:function(msg){
            return $("#modal-error-tmpl").tmpl(msg)
        },
        show:function(ev,item){
            console.log("show new contact",item)
            this.renderHeader();
            this.body.html(item.el)
            this.buttons.html(item.links)
            this.registerEventHandlers(this.buttons);
            if(item.notice){
                this.notice.html(item.notice)
                setTimeout(this.proxy(function(){
                    this.notice.find(".alert").addClass("fade","in").alert('close');
                }),2000);
            }
            this.body.find('.amountSelect').chosen();
            this.body.find('.payment').selectmenu();
        },
        getContact:function(contact){
            this.contact=contact
            this.doGetContact(this.contact.url)
            return false;
        },
        getContactUrl:function(url){
            console.log("getContactUrl",url)
            this.url=url;
            this.doGetContact(this.url)
        },
        doGetContact:function(url){
            console.log("url",url)
            Contact.get(url,this.proxy(function(data){

            }),this.failure,{})
            this.render();
        },
        render:function(){
            this.renderHeader();
            this.showProgress();
            this.defaultButtons();
            this.el.modal();
        } ,
        renderHeader:function(){
            this.header.html($("#modal-header-contact-tmpl").tmpl())
        },
        showProgress:function(){
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
            var error='<strong>Sorry!</strong> an error occured, please try again later'
            this.showError({message:error})
        },
        edit:function(ev){
            try{
                var url=$(ev.currentTarget).attr("href");
                this.App.trigger("contacts:edit:show",url);
            }  catch(e){
                console.log("err",e)
            }
            return false;
        },
        registerEventHandlers:function(el){
            var del=el.find(".delete")
            del.on('ajax:success', this.proxy(function() {
                this.deActivate();
            }));
            del.on('ajax:loading', function() {
                $(this).button('loading')
            });
            del.on('ajax:failure', this.proxy(function() {
                this.failure(null);
            }));
        }
    });
})

jQuery(function($){
    window.Application = Spine.Controller.create({
        elements:{
            '#deposit-form':'depositEl',
            "#wallet":"walletEl",
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




