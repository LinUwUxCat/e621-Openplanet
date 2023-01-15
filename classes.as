class Tags{
    array<string> tags;
    Tags(array<string> s){
        tags = s;
    }
    string toUrl(){
        string r;
        for (uint i=0; i<this.tags.Length; i++){
            r += this.tags[i];
            if (i!=this.tags.Length-1) r+="+";
        }
        return r;
    }
};

/**
 * Post is the class representing an e621 post, with tags, the image, etc.
 * It "only" contains the json representing the post but provides several functions able to access that Json.
 */
class Post{
    Json::Value json;
    Post(Json::Value j){
        json = j;
    }
    Post(){}
    Json::Value generalTags(){
        string r = "";
        if (!json.HasKey("tags")) return r;
        return json["tags"]["general"];
    }
    string getUrl(){
        if (!json.HasKey("file")) return "";
        if (json['file']['url']==null) return "";
        return json["file"]["url"];
    }

    string getSampleUrl(){
        if (!json.HasKey("sample")) return "";
        if (json['sample']['url']==null) return "";
        return json["sample"]["url"];
    }

    uint64 getId(){
        if (!json.HasKey("id")) return 0;
        return json["id"];
    }
};