var Contact=Spine.Model.setup("ContactItem",[
    "id",
    "first_name",
    "last_name",
    "contact_group_id",
    "user_id",
    "carrier",
    "phone_number",
    "collection_url"
])


Contact.extend({
        base_url:"http://localhost:3000/",
        new:function(url,succ,err){
            $.ajax({
                type: "GET",
                url:url+".js",
                contentType:"application/js",
                success: succ,
                error:err
            });
        } ,

        get:function(url,succ,err,params){
            $.ajax({
                type: "GET",
                url:url+".js",
                contentType:"application/json",
                data:params,
                success: succ,
                error:err
            });
        } ,
        fakeItem:function(){
            return {
                Branch_url:"",
                created_time_ago:"1 minute ago",
                memberships_count:"40",
                sub_tree_size:"0",
                latest_tip:"The Beginning of time",
                icon_url:"/assets/image_7.jpg",
                collection_url:"http://localhost:3000/trees/2/all_branches"
            }
        }
    }
);
