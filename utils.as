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
        string r = "{}";
        if (!json.HasKey("tags")) return Json::Parse(r);
        return json["tags"]["general"];
    }

    Json::Value artistTags(){
        string r = "{}";
        if (!json.HasKey("tags")) return Json::Parse(r);
        return json["tags"]["artist"];
    }

    Json::Value copyrightTags(){
        string r = "{}";
        if (!json.HasKey("tags")) return Json::Parse(r);
        return json["tags"]["copyright"];
    }

    Json::Value characterTags(){
        string r = "{}";
        if (!json.HasKey("tags")) return Json::Parse(r);
        return json["tags"]["character"];
    }

    Json::Value metaTags(){
        string r = "{}";
        if (!json.HasKey("tags")) return Json::Parse(r);
        return json["tags"]["meta"];
    }
    
    Json::Value speciesTags(){
        string r = "{}";
        if (!json.HasKey("tags")) return Json::Parse(r);
        return json["tags"]["species"];
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

    /**
     * returns a vec3 with the following:
     * - x is the total score
     * - y is the upvote score
     * - z is the downvote score
     */
    vec3 getScore(){
        if (!json.HasKey('score'))return vec3(0,0,0);
        int total = json['score']['total'];
        int up = json['score']['up'];
        int down = json['score']['down'];
        return vec3(total, up, down);
    }

    /**
     * if formatted is true, will return colored and verbose output (Safe, Questionable, Explicit)
     * else, will return direct output (s, q, e)
     */
    string getRating(bool formatted){
        if (!json.HasKey('rating')){
            if (!formatted)return "e"; else return "\\$f00Explicit";
        }
        string r = json['rating'];
        if (!formatted) return r;
        if (r=="s"){
            return "\\$0f0Safe";
        } else if (r=="q"){
            return "\\$cc1Questionable";
        } else {
            return "\\$f00Explicit";
        }
    }

    uint64 getId(){
        if (!json.HasKey("id")) return 0;
        return json["id"];
    }
};



bool ColoredButton(const string &in text, vec4 rgb, vec2 size){
    UI::PushStyleColor(UI::Col::Button, rgb);
    UI::PushStyleColor(UI::Col::ButtonHovered, rgb);
    UI::PushStyleColor(UI::Col::ButtonActive, rgb);
    bool r = UI::Button(text, size);
    UI::PopStyleColor(3);
    return r;
}

void renderTagList(Json::Value tags, vec4 rgb){
    for(uint tagindex = 0; tagindex<tags.Length; tagindex++){
        string tag = tags[tagindex];
        int buttonWidth = Draw::MeasureString(tag).x + BUTTON_PADDING.x + 12;
        if(buttonWidth >= spaceAvailable){
            UI::NewLine();
            spaceAvailable = UI::GetWindowSize().x;
        }
        if(ColoredButton(tag, rgb,Draw::MeasureString(tag)+BUTTON_PADDING))print(tag);
        spaceAvailable -= buttonWidth;
        UI::SameLine();
    }
}