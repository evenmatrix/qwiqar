jQuery(function($){
    window.TabController=Spine.Controller.create({
        elements:{
            '.tab-body':"tabBody",
            ".nav.nav-tabs":'tabsNav',
            ".nav.nav-tabs li":"handlers"
        },
        proxied:['keydown','selectTabFromHash','popState'],
        tabIDprefix:"tab-",
        init:function(){
           // this.tabsNav = this.el.find('ul.nav');
            this.handlers.each(this.proxy(function(i,item){
                //console.log("item",$(item).find('a'))
                var target=($(item).find('a').data('target').split('#')[1]||$(item).find('a').attr('href').split('#')[1])
                $(item)
                    .attr('role','tab')
                    .attr('id',this.tabIDprefix + target);
            }));
            this.tabsNav.find('a').attr('tabindex','-1');
            this.tabsNav.find('a').click(this.proxy(this.click));
            this.tabBody.find('>div').each(this.proxy(function(i,item){
                $(item)
                    .addClass('tab-panel')
                    .attr('role','tab-panel')
                    .attr('aria-hidden', true)
                    .attr('aria-labelledby',this.tabIDprefix + $(item).attr('id'));
            }));

            this.tabsNav.find('a').keydown(this.keydown)
            this.tabsNav.find('a:first').click();
        },
        selectTab:function(tab,fromHashChange){
            /**if(!fromHashChange){
             $.historyLoad(tab.attr('href').replace('#','') );
             }else{**/
            this.tabsNav.find('li.'+this.options.activeTabClass).removeClass(this.options.activeTabClass).find('a').attr('tabindex','-1');
            tab.attr('tabindex','0').parent().addClass(this.options.activeTabClass);
            this.tabBody.find('>div.'+this.options.activePanelClass).attr('aria-hidden',true).removeClass(this.options.activePanelClass);
            var target=($(tab).data('target')||$(tab).attr('href'))
            //console.log("target", target)
            $(target).addClass(this.options.activePanelClass).attr('aria-hidden',false);
            ///tab[0].focus();
            //this.saveState(tab);
            this.App.trigger(tab.data("action"),$(tab).attr('href'))
        },
        click:function(event){
            this.selectTab($(event.currentTarget));
            return false;
        },
        keydown:function(event){
            var currentTab = $(event.target).parent();
            switch(event.keyCode){
                case 37: // left arrow
                case 38: // up arrow
                    if(currentTab.prev().size() > 0){
                        this.selectTab( currentTab.prev().find('a'));
                    }
                    break;
                case 39: // right arrow
                case 40: // down arrow
                    if(currentTab.next().size() > 0){
                        this.selectTab( currentTab.next().find('a') );
                    }
                    break;
                case 36: // home key
                    this.selectTab( this.tabsNav.find('li:first a') );
                    break;
                case 35: // end key
                    this.selectTab( this.tabsNav.find('li:last a') );
                    break;
            }
        },
        saveState:function(tab){
            if (!history.pushState) return;
            history.pushState(tab.attr('href'),"","");
        },
        // This is the onpopstate event handler that restores historical states.
        popState:function(event) {
            if(event.state)
                this.selectTabFromHash(event.state)

        },
        selectTabFromHash:function(hash){
            var currHash = hash || window.location.hash;
            var hashedTab = this.tabsNav.find('a[href=#'+ currHash.replace('#','') +']');
            if( hashedTab.size() > 0){
                this.selectTab(hashedTab,true);
            }
            else {
                this.selectTab( this.tabsNav.find('a:first'),true);
            }
            //return true/false
            return !!hashedTab.size();
        }

    })

})
jQuery(function($){
    window.TabButtonController=Spine.Controller.create({
        elements:{
            '.tab-body':"tabBody",
            ".btn-group":'tabsNav',
            ".btn-group a":"handlers"
        },
        proxied:['keydown','selectTabFromHash','popState'],
        tabIDprefix:"tab-",
        init:function(){
            // this.tabsNav = this.el.find('ul.nav');
            this.handlers.each(this.proxy(function(i,item){
                //console.log("item",$(item).find('a'))
                var target=($(item).data('target').split('#')[1]||$(item).find('a').attr('href').split('#')[1])
                $(item)
                    .attr('role','tab')
                    .attr('id',this.tabIDprefix + target)
                    .attr('tabindex','-1')
                    .click(this.proxy(this.click))
            }));
            this.tabBody.find('.tab-panel').each(this.proxy(function(i,item){
                $(item)
                    .attr('role','tab-panel')
                    .attr('aria-hidden', true)
                    .attr('aria-labelledby',this.tabIDprefix + $(item).attr('id'));
            }));

            this.handlers.keydown(this.keydown)
            this.tabsNav.find('a:first').click();
        },
        selectTab:function(tab,fromHashChange){
            /**if(!fromHashChange){
             $.historyLoad(tab.attr('href').replace('#','') );
             }else{**/
            this.tabsNav.find('li.'+this.options.activeTabClass).removeClass(this.options.activeTabClass).find('a').attr('tabindex','-1');
            tab.attr('tabindex','0').parent().addClass(this.options.activeTabClass);
            this.tabBody.find('>div.'+this.options.activePanelClass).attr('aria-hidden',true).removeClass(this.options.activePanelClass);
            var target=($(tab).data('target')||$(tab).attr('href'))
            //console.log("target", target)
            $(target).addClass(this.options.activePanelClass).attr('aria-hidden',false);
            ///tab[0].focus();
            //this.saveState(tab);
            this.App.trigger(tab.data("action"),$(tab).attr('href'))
        },
        click:function(event){
            this.selectTab($(event.currentTarget));
            return false;
        },
        keydown:function(event){
            var currentTab = $(event.target).parent();
            switch(event.keyCode){
                case 37: // left arrow
                case 38: // up arrow
                    if(currentTab.prev().size() > 0){
                        this.selectTab( currentTab.prev().find('a'));
                    }
                    break;
                case 39: // right arrow
                case 40: // down arrow
                    if(currentTab.next().size() > 0){
                        this.selectTab( currentTab.next().find('a') );
                    }
                    break;
                case 36: // home key
                    this.selectTab( this.tabsNav.find('li:first a') );
                    break;
                case 35: // end key
                    this.selectTab( this.tabsNav.find('li:last a') );
                    break;
            }
        },
        saveState:function(tab){
            if (!history.pushState) return;
            history.pushState(tab.attr('href'),"","");
        },
        // This is the onpopstate event handler that restores historical states.
        popState:function(event) {
            if(event.state)
                this.selectTabFromHash(event.state)

        },
        selectTabFromHash:function(hash){
            var currHash = hash || window.location.hash;
            var hashedTab = this.tabsNav.find('a[href=#'+ currHash.replace('#','') +']');
            if( hashedTab.size() > 0){
                this.selectTab(hashedTab,true);
            }
            else {
                this.selectTab( this.tabsNav.find('a:first'),true);
            }
            //return true/false
            return !!hashedTab.size();
        }

    })

})

jQuery(function($){
    window.TabButtonMenuController=Spine.Controller.create({
        elements:{
            '.tab-body':"tabBody",
            ".btn-group .dropdown-menu":'tabsNav',
            ".btn-group .dropdown-menu li":"handlers"
        },
        proxied:['keydown','selectTabFromHash','popState'],
        tabIDprefix:"tab-",
        init:function(){
            console.log("handlers",this.handlers)
            this.handlers.each(this.proxy(function(i,item){
                var target=($(item).find('a').attr('href').split('#')[1])||($(item).data('target').split('#')[1])
                $(item)
                    .attr('role','tab')
                    .attr('id',this.tabIDprefix + target)
                    .attr('tabindex','-1')
                    .find("a").click(this.proxy(this.click))
            }));

            this.tabBody.find('.tab-panel').each(this.proxy(function(i,item){
                $(item)
                    .attr('role','tab-panel')
                    .attr('aria-hidden', true)
                    .attr('aria-labelledby',this.tabIDprefix + $(item).attr('id'));
            }));

            this.handlers.keydown(this.keydown)
            //this.tabsNav.find('a:first').click();
        },
        selectTab:function(tab,fromHashChange){
            this.tabsNav.find('li.'+this.options.activeTabClass).removeClass(this.options.activeTabClass).find('a').attr('tabindex','-1');
            tab.attr('tabindex','0').parent().addClass(this.options.activeTabClass);
            this.tabBody.find('>div.'+this.options.activePanelClass).attr('aria-hidden',true).removeClass(this.options.activePanelClass);
            var target=($(tab).data('target')||$(tab).attr('href'))
            //console.log("target", target)
            $(target).addClass(this.options.activePanelClass).attr('aria-hidden',false);
            ///tab[0].focus();
            //this.saveState(tab);
            this.App.trigger(tab.data("action"),$(tab).attr('href'))
            console.log(this.tabsNav)
            this.tabsNav.parent().removeClass("open")
        },
        click:function(event){
            this.selectTab($(event.currentTarget));
            return false;
        },
        keydown:function(event){
            var currentTab = $(event.target).parent();
            switch(event.keyCode){
                case 37: // left arrow
                case 38: // up arrow
                    if(currentTab.prev().size() > 0){
                        this.selectTab( currentTab.prev().find('a'));
                    }
                    break;
                case 39: // right arrow
                case 40: // down arrow
                    if(currentTab.next().size() > 0){
                        this.selectTab( currentTab.next().find('a') );
                    }
                    break;
                case 36: // home key
                    this.selectTab( this.tabsNav.find('li:first a') );
                    break;
                case 35: // end key
                    this.selectTab( this.tabsNav.find('li:last a') );
                    break;
            }
        },
        saveState:function(tab){
            if (!history.pushState) return;
            history.pushState(tab.attr('href'),"","");
        },
        // This is the onpopstate event handler that restores historical states.
        popState:function(event) {
            if(event.state)
                this.selectTabFromHash(event.state)

        },
        selectTabFromHash:function(hash){
            var currHash = hash || window.location.hash;
            var hashedTab = this.tabsNav.find('a[href=#'+ currHash.replace('#','') +']');
            if( hashedTab.size() > 0){
                this.selectTab(hashedTab,true);
            }
            else {
                this.selectTab( this.tabsNav.find('a:first'),true);
            }
            //return true/false
            return !!hashedTab.size();
        }

    })

})