//= require typeahead
//= require hogan.js
//= require model/contact
//= require_self
jQuery(function($){
    window.NewContact = Spine.Controller.create({
        elements:{
            ".modal-header .contactHeader":"header",
            ".modal-body":"body",
            ".modal-footer":"footer",
            ".modal-footer .btns":"buttons"
        },
        events:{
            "submit #newContactForm" :"create"
        },
        proxied: ["render",'activate','deActivate','success',"showContact",'failure','showContactForm','showEditForm'],
        init: function(){
            $("#newContactDialog").bind("contacts:new",this.showContactForm)
        },
        template:function(data){
        },
        templateProgress:function(){
            return $("#modal-progress-tmpl").tmpl()
        },
        templateError:function(msg){
            return $("#modal-error-tmpl").tmpl(msg)
        },
        show:function(){
            console.log("show new contact",this.el)
            this.header.html($("#modal-header-contact-new-tmpl").tmpl())
            this.defaultButtons();
            this.activate();
            this.render();
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
            this.el.modal();
        },
        deActivate:function(){
            this.el.modal('hide');
        },
        getContactForm:function(){
            this.showProgress();
            Contact.new(this.url,this.proxy(function(data){

            }),this.proxy(function(data){
                console.log("error",data)
                var error='<strong>Sorry!</strong> an error occured, please try again later'
                this.showError({message:error})
            }))
        },
        showContactForm:function(ev,item){
            console.log("item",item);
            this.renderForm(item.el);
            this.createButton=this.body.find('.btn.create')
            this.buttons.html(item.links)
        },
        renderForm:function(form){
            this.body.html(form)
            this.body.find('.xfile').customFileInput();
            this.body.find('.xselect').selectmenu();
        },
        create:function(ev){
            if(this.createButton.hasClass("disabled")) return false;
            var url=$(ev.target).attr('action');
            var data=$(ev.target).serialize()
            $.ajax({
                type: "POST",
                url: url+".js",
                data:data,
                success:this.success
            })
            this.createButton.button('loading')
            return false;
        },
        render:function(){
            this.getContactForm();
        },
        success:function(data){
            console.log("data",data);
        },
        failure:function(data){
            console.log("error",data.responseText)
            //eval(data.responseText)
            //this.createButton.addClass("disabled")
            var error='<strong>Sorry!</strong> an error occured, please try again later'
            this.showError({message:error})
        }
    });
})
jQuery(function($){
    window.EditContact = Spine.Controller.create({
        elements:{
            ".modal-header .contactHeader":"header",
            ".modal-body":"body",
            ".modal-footer":"footer",
            ".modal-footer .btns":"buttons"
        },
        events:{
            "click .edit":"getEditForm" ,
            "submit #editContactForm":"doEdit" ,
            "click .back":"back"
        },
        proxied: ["render","show",'activate','deActivate','success',"showContact",'failure','showContactForm','showEditForm'],
        init: function(){
            $("#newContactDialog").bind("contacts:edit",this.showEditForm)
            this.App.bind("contacts:edit:show",this.show)
        },
        template:function(data){
        },
        templateProgress:function(){
            return $("#modal-progress-tmpl").tmpl()
        },
        templateError:function(msg){
            return $("#modal-error-tmpl").tmpl(msg)
        },
        show:function(url){
            this.url=url;
            this.render();
            this.getEditForm();
        },
        render:function(){
            this.header.html($("#modal-header-contact-edit-tmpl").tmpl())
            this.showProgress();
            this.defaultButtons();
            this.el.modal();
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

        },
        getEditForm:function(){
            console.log("url",this.url)
            Contact.get(this.url,this.proxy(function(data){

            }),this.failure,{})
            return false;
        },
        showEditForm:function(ev,item){
            this.renderForm(item.el);
            this.doEditButton=this.body.find('.btn.doEdit')
            this.buttons.html(item.links)
        },
        renderForm:function(form){
            this.body.html(form)
            this.body.find('.xfile').customFileInput();
            this.body.find('.xselect').selectmenu();
        },
        doEdit:function(ev){
            if(this.doEditButton.hasClass("disabled")) return false;
            var url=$(ev.target).attr('action');
            var data=$(ev.target).serialize()
            $.ajax({
                type: "PUT",
                url: url+".js",
                data:data,
                error:this.failure,
                success:this.success
            })
            this.doEditButton.button('loading')
            return false;
        },
        success:function(data){
            console.log("data",data);
        },
        failure:function(data){
            console.log("error",data.responseText)
            //eval(data.responseText)
            //this.createButton.addClass("disabled")
            var error='<strong>Sorry!</strong> an error occured, please try again later'
            this.showError({message:error})
        },
        back:function(ev){
            var url=$(ev.currentTarget).attr("href");
            this.App.trigger("contacts:show",url);
            return false;
        }
    });
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
        proxied: ["render",'activate','deActivate','success',"show",'failure','showContactForm','showEditForm','getDeleteForm','getContact'],
        init: function(){
            $('#newContactDialog').bind("contacts:show",this.show)
            this.App.bind("contacts:show",this.getContact)
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
        getContact:function(url){
            this.render();
            this.url=url
            Contact.get(this.url,this.proxy(function(data){

            }),this.failure,{})
            return false;
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
            console.log("data",data);
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
    window.ContactItemController = Spine.Controller.create({
        elements:{
            '.dropdown-menu':'dropdownMenu'
        },
        events:{
            'click .contact':'show'
        },
        proxied:["remove","render","update"],
        template:function(data){
            return $("#branch-item-tmpl").tmpl(data)
        },
        init: function(){
            $('#branches').bind("branches:update",this.update)
        },
        update:function(ev,data){
            if($(data.el).attr("id")==this.el.attr("id")){
                this.render($(data.el));
                this.App.trigger("branches:update")
            }

        },
        render: function(el){
            this.el.replaceWith(el);
            return this;
        },
        remove: function(){
            this.el.remove();
        },
        show:function(ev){
            this.currentAnchor=$(ev.currentTarget);
            this.App.trigger("contacts:show",this.currentAnchor.attr('href'))
            return false;
        }
    })
})

jQuery(function($){
    window.TypeAheadController = Spine.Controller.create({
        elements:{
            '.typeahead':'typeahead',
            ".tool-buttons":"toolButtons"
        },
        events:{
            "keydown .typeahead":"checkInput",
            "keyup .typeahead":"checkInput",
            "click .cancel":"cancel"
        },
        proxied:["remove","render","update","onOpened","onSelected","template","doSearch"],
        template:function(data){
           return $("#contact-search-tmpl").tmpl(data).html()
        },
        templateToolBarButton:function(data){
            return $("#tool-buttons-search-tmpl").tmpl(data)
        },
        renderToolButtons:function(state){
            this.toolButtons.html(this.templateToolBarButton(state))
        },
        init: function(){
            this.url=this.el.attr('action')
            this.initTypeahead();
            this.el.find(".twitter-typeahead").css({"display":"block"})
            this.el.on("submit",this.doSearch)
        },
        onOpened:function(){
        },
        onSelected:function($e,datum){
            console.log("datum",datum)
            this.App.trigger("contacts:show",datum.url)
        },
        checkInput:function(e){
            if (e.which == 13 && !e.shiftKey) {
                this.doSearch();
                return false;
            }
           if(this.typeahead.val()==""){
               this.toolButtons.empty();
           }else{
               this.renderToolButtons({search:true})
           }
        },
        cancel:function(){
            this.typeahead.typeahead('setQuery',"");
            this.renderToolButtons({search:false})
            if(this.onCancel){
                this.onCancel()
            }
            return false;
        },
        initTypeahead:function(){

            this.typeahead.typeahead(
                {
                    name: 'Contacts',
                    remote: this.url+"?q=%QUERY",
                    template: this.template,
                    valueKey:"name"
                }
            ).on("typeahead:selected",this.onSelected).on("typeahead:opened",this.onOpened);
        },

        doSearch:function(ev){
            console.log("doSearch",this.typeahead.val())
            if(this.onSearch){
                //this.onSearch({url:this.el.attr('action'),data:this.el.serialize()})
            }
            return false;
        }
    })
})

jQuery(function($){
    window.Contacts = Spine.Controller.create({
        elements:{
            ".contacts .items":"itemsEl",
            ".contacts .items .item":'handler',
            "#newContactDialog":"ContactDialog",
            "#newContact":"newContactAnchor",
            ".contacts .load":"progressEl",
            ".search-form":"searchForm",
            '.search-form input':"searchInput",
            ".tool-buttons":"toolButtons"
        },

        events:{
            "click #newContact":"showNewContact"
         },

        proxied:["show","prefetchComplete","scroll","doSearch","cancelSearch"],

        init: function(){
            this.items=[];
            this.params=this.params||{}
            console.log("params",this.params)
            $(document).on("scroll",this.scroll)
            this.handler.each(this.proxy(function(i){
                ContactItemController.init({el:this.handler[i]})
            }))
            Contact.bind('create',this.onCreate)
            this.App.bind("show:contacts",this.show)
            this.newContact = NewContact.init({el:this.ContactDialog,url:this.newContactAnchor.attr('href')})
            this.contactController=ContactController.init({el:this.ContactDialog})
            this.edit=EditContact.init({el:this.ContactDialog})
            $('#newContactDialog').bind("contacts:fetch",this.prefetchComplete)
            this.typeAheadController=TypeAheadController.init({el:this.searchForm,onSearch:this.doSearch,onCancel:this.cancelSearch})
            this.App.bind("contacts:search",this.doSearch)
        },
        template: function(items){
        },
        create:function(ev,data){
            this.addOne(data)
        },
        show:function(url){
            this.url=url;
            this.renderToolButtons();
            if(!this.prefetching){
                this.render();
            }
        },
        renderToolButtons:function(state){
            this.toolButtons.html($("#tool-buttons-search-tmpl").tmpl(state))
         },
        render:function(){
            if(!(this.handler.length>0)) {
                this.showProgress();
                this.prefetch();
            }
        },

        addOne:function(item){
            try{
                var itemEl= ContactItemController.init({el:item})
                this.itemsEl.append(item);
                this.refresh();
            } catch(e) {
                console.log(e)
            }
        },
        empty:function(){
            this.itemsEl.empty();
        },
        refresh:function(){
            this.handler= this.itemsEl.find(".item")
            console.log('refresh')
        },
        hideProgress:function(){
            if(this.progress)this.progress.remove();
        },
        showProgress:function(obj){
            this.hideProgress();
            this.progress=$("#spinner-tmpl").tmpl(obj);
            this.progress.appendTo(this.progressEl);
        },
        loadMore:function(){
            if(!this.prefetching){
                this.showProgress();
                this.prefetch();
            }
        },
        addAll:function(items){
            $.each(items,this.proxy(function(i){
                this.addOne($(items[i]))
            }) )
        },
        prefetch:function(){
            if(this.prefetching)return
            this.prefetching=true;
            $.ajax({
                type: "GET",
                url:this.url+".js",
                contentType:"application/json",
                data:this.params,
                success: null,
                error:this.onError
            });
        },
        prefetchComplete:function(ev,data){
            console.log("data",data)
            this.hideProgress();
            this.prefetching=false;
            this.params=data.params
            this.remaining=data.remaining//the page set by the server or may me we should maintain state?this.page+=1
            this.empty=data.empty;
            if(this.empty) {
                this.showEmptyMessage();
                return;
            }
            this.addAll($(data.contacts))
        },

        shouldScroll: function(){
            return ($(window).scrollTop() + $(window).height() > $(document).height() - 100);
        },
        scroll: function(vp){
            var shouldScroll = this.shouldScroll();
            console.log("shouldScroll",shouldScroll);
            if(shouldScroll){
                this.loadMore();
            }
        },
        doAction:function(ev){
            this.currentAnchor=$(ev.currentTarget);
            this.itemsEl.find('li.item .actions li.active').removeClass('active')
            this.current= $(ev.currentTarget).closest('li');
            this.current.addClass("active");
            action=this.currentAnchor.data("action");
            console.log("action",action)
            this.App.trigger(action,this.currentAnchor.attr("data-url"),this.current)
            this.currentAnchor.closest(".actions").removeClass("open")
            return false;
        },
        showNewContact:function(ev){
            ev.preventDefault() ;
            this.newContact.show();
        },
        doSearch:function(ev){
            console.log("doSearch")
            this.itemsEl.empty();
            this.showProgress();
            var url=ev.url;
            var data=ev.data
            $.ajax({
                type: "GET",
                url: url+".js",
                data:data,
                error:this.failure,
                success:this.success
            })
            //this.renderToolButtons({search:true});
            return false;
        },
        cancelSearch:function(){

         }
    })

})