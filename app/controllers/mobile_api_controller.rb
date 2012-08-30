class MobileApiController < ApplicationController

  
  
  def index
    
  end
  
  
  def count(counting)#compleeted
    i=0;
    if !counting.nil?
      counting.each do |e|
        i=i+1
      end
    end
    return i
  end 
  
def addcoments #compleeted
  
  time = Time.new()
  userid = params[:userid]
  memoryid = params[:memoryid]
  comment = params[:comment]
  cr = params[:createdat]
  date = params[:date]
  msg = Array.new
  if ( !userid.nil? && !memoryid.nil? )
    var = "not null"
    com=Comment.new
    com.content = comment
    com.user_id = userid
    com.memory_id = memoryid
    com.updated_at = time
      if com.save
        msg={"message"=>"Comment inserted"}

      else
        msg={"message"=>"inserted failed"}

      end
    else
    msg={"message"=>"please provide the values"}

    end
   render :json =>msg

end


def addfavourite # completed

memoryid = params[:memoryid]
userid = params[:userid]
msg = Array.new
  if ( !memoryid.nil? && !userid.nil? )
        memuser = Memories_user.find(:all, :conditions =>["memory_id = ? AND user_id = ? ",memoryid, userid] )
        countmemuser = count(memuser)   

      if(countmemuser > 0)
         Memories_user.delete_all(:memory_id => memoryid, :user_id => userid)
        userids = Memories_user.find(:all, :conditions =>[" memory_id = ?",memoryid] )
        countuserids = count(userids)
        msg= {"message"=>"User unfavourite successfully","favcount"=>countuserids.to_s}
      else
        memusr2 = Memories_user.new
        memusr2.memory_id = memoryid
        memusr2.user_id = userid
        memusr2.save
        memuser2 = Memories_user.find(:all, :conditions =>["memory_id = ?",memoryid])
        countmemuser1 = count(memuser2)    
        msg={"message"=>"successfully inserted","favcount"=>countmemuser1.to_s}   

      end   
    else
        msg={"message"=>"Please provide all Values"}  
    end
   
render :json => msg

  end 

def addmemoriedetails # partially compleeted
name = params[:name]
desc = params[:desc]
userid = params[:userid]
decade = params[:decade]
catid = params[:catid]
img = params[:file]   
msg = Array.new

type = File.extname(img.to_s)   

size = img.size( )
img1 = File.basename(img,'.jpg') 
img1=img1.rstrip
img1 = img1.gsub( /[^\w\.\-]/ , '_')  
  t=Time.new      # here t is for image name purpus
  t1=Time.new      # here t1 is for inserting (time function ) purpus
  t = t.inspect
  t=t.sub(' ','')
  t=t.sub(' ','')
  img1=img1+t+".jpg"
  path = "images/"+img1
 
 if ( name.length!=0 && catid!=0)
 
  mem = Memorie.new
  mem.name = name
  mem.description =desc 
  mem.user_id = userid
  mem.decade = decade
  mem.created_at = t1
  mem.updated_at = t1
  mem.save
  catmemory = Categories_memorie.new
  catmemory.category_id = catid
  catmemory.memory_id = mem.id
  if catmemory.save
 
    images = Image.new
    images.image_file_name = img1
    images.image_content_type = type
    images.image_file_size = size
    images.image_updated_at = t1
    images.memory_id = mem.id
    images.user_id = userid
    images.created_at = t1
    images.save

    #path = File.join(directory, name)

    #File.open(path, "wb") { |f| f.write(upload['datafile'].read) }





    msg={"message"=>"added sucessfully"}

  else
    msg={"message"=>"fail to add"}
 
  end
  
else
 msg={"message"=>"provide Values"}
 end
 
render :json => msg
end 
  
  
  def B  # compleeted

  memuserid = params[:memuserid]
  userid = params[:userid]
  i=0
  msg = Array.new

  if( !memuserid.nil? && !userid.nil?)

  a = Memorie.find(:all,:conditions=>["user_id =? AND id=?",userid,memuserid])
  a.each do |a1|

  c = Categories_memorie.find_by_memory_id(a1.id)
  if !c.nil?
  d = Categorie.find_by_id(c.category_id)
  if !d.nil?
    b = User.find_by_id(a1.user_id)
  if !b.nil?

  ccount = Comment.find(:all,:conditions =>["memory_id=?",a1.id])
  comcount = count(ccount)
  fll = Following.find(:all, :conditions =>["followee_id= ?",a1.user_id])
  fllcount = count(fll)
  if fllcount > 0
  status = 1
  else
  status = 0
  end
  memusr = Memories_user.find(:all, :conditions =>["memory_id= ? AND user_id=?",a1.id,userid])
  memcount = count(memusr)
  if memcount > 0
  fstatus = 1
  else
  fstatus = 0
  end
  img = Image.find_by_memory_id(a1.id)
  if !img.nil?
  if img.image_file_name!='null'
    pic=img.image_file_name
    else 
    pic="no-image.png"
    end
  else  
  pic="no-image.png"
  end

  memusr2 = Memories_user.find(:all, :conditions =>["memory_id=?",a1.id])
  fcount = count(memusr2)
#    msg[i]={"categoryId":"25","categoryName":"Money & Finance","memorieId":"195","memorieName":"Testing","memorydescription":"","MemoryCreatedDate":"2012-06-19 23:20:29","memorieView":"48","memoriedecade":"","likes":"","coomentscount":"0","followscount":"followerscount1","status":"0","favstatus":"0","favcount":"0","MemorieImage":"http:\/\/myworkdemo.com\/doyourememberme\/services\/images\/20120619232029.jpg","UserId":"45","UserName":"Veerendra"},

#pic="http:\/\/myworkdemo.com\/doyourememberme\/services\/images\/20120619232029.jpg"
    msg[i]={"categoryId"=>d.id.to_s,"categoryName"=>d.name,"memorieId"=>a1.id.to_s,"memorieName"=>a1.name,"memorydescription"=>a1.description,"MemoryCreatedDate"=>a1.created_at.to_s,"memorieView"=>a1.views.to_s,"memoriedecade"=>a1.decade.to_s,"coomentscount"=>comcount.to_s,"followscount"=>fllcount.to_s,"status"=>status.to_s,"favstatus"=>fstatus.to_s,"favcount"=>fcount.to_s,"MemorieImage"=>pic,"UserId"=>b.id.to_s,"UserName"=>b.first_name,"likes"=>"535"}
  i=i+1
  end
  end
  end
  end
  else 
  msg={"message"=>"please provide values"} 

  end 
  #msg[0]={"categoryId"=>"25","categoryName"=>"Money & Finance","memorieId"=>"195","memorieName"=>"Testing","memorydescription"=>"","MemoryCreatedDate"=>"2012-06-19 23:20:29","memorieView"=>"48","memoriedecade"=>"","likes"=>"","coomentscount"=>"0","followscount"=>"followerscount1","status"=>"0","favstatus"=>"0","favcount"=>"0","MemorieImage"=>"http:\/\/myworkdemo.com\/doyourememberme\/services\/images\/20120619232029.jpg","UserId"=>"45","UserName"=>"Veerendra"}
 render :json =>msg
 
  end 

  def GetMemories # completed

 
 
  msgall = Array.new
  
 
  start = params[:start]
  
   i=0
   m = Memorie.find(:all, :limit => 50)
   

   #m = Memorie.find(:all, :limit => 30, :order=> 'created_at desc')
   m.each do |mem|
    f = User.find_by_id(mem.user_id)
    c = Categories_memorie.find_by_memory_id(mem.id)
    cat = Categorie.find_by_id(c.category_id)
    #com = Comment.find(:all,:conditions =>["memory_id=?",mem.id])
    image = Image.find_by_memory_id(mem.id)
      if image.image_file_name =="null"
          pic="no-image.jpg"
      
    else
      pic = image.image_file_name
    end
 #pic="no-image.jpg"

#msgall[i]=pic
 msgall[i]={"user_name"=>f.first_name,"user_id"=>f.id,"category_name"=>cat.name,"name"=>mem.name,"date_of_memory"=>mem.date_of_memory, "comments_count"=>mem.comments_count, "follows_count"=>535, "description"=>mem.description, "created_at"=>mem.created_at, "category_id"=>cat.id, "views"=>mem.views, "updated_at"=>mem.updated_at, "decade"=>mem.decade.to_s, "is_anonymous"=>mem.is_anonymous,"image"=>pic,   "likes_count"=>"123", "id"=>mem.id,"favcount"=>"0"}
   
   # msgall[i]={"user_name"=>f.first_name,"category_id"=>cat.id.to_s,"category_name"=>cat.name,"memorieId"=>mem.id.to_s,"memorieName"=>mem.name,"memorieView"=>mem.views.to_s,"memoriedecade"=>mem.decade,"MemorieImage"=>pic,"MemoryCreatedDate"=>mem.created_at,"UserId"=>f.id.to_s,"coomentscount"=>commentcount.to_s,"followscount"=>fcount.to_s,"status"=>status.to_s,"description"=>mem.description,"favstatus"=>favstatus.to_s,"favcount"=>memcount2.to_s};
   i =i +1

   end # for each




  msg=Array.new
  msg = {"memories"=>msgall}
   render :json =>msg
  end # end for GetMemories def


  def comments #completed
  memuserid = params[:memuserid]
  userid = params[:userid]
  i=0
  msg = Array.new
  if !memuserid.nil?
  cm1 = Comment.find(:all,:conditions=>["user_id=?",memuserid])
  cm1.each do |cm|
  cm2 = Comment.find(:all,:conditions=>["user_id=?",cm.user_id])
  countcm2 = count(cm2)
  us = User.find_by_id(cm.user_id)
  mem = Memorie.find_by_id(cm.memory_id)
  if !mem.nil? 
  usr2 = User.find_by_id(mem.user_id)
  img = Image.find_by_memory_id(cm.user_id)
  if img.image_file_name != 'null'
  pic=img.image_file_name 
  else
  pic="no-image.png"
  end
  cm3 = Comment.find(:all,:conditions=>["user_id=?",cm.memory_id])
  countcm3 = count(cm3)
  mem2 = Memorie.find_by_id(cm.memory_id)
  fll = Following.find(:all,:conditions =>["followee_id=? AND follower_id=?",memuserid,userid])
  fcount = count(fll)
  if fcount > 0
  status = 1
  else
  status = 0
  end
  cmemory = Categories_memorie.find_by_memory_id(cm.memory_id)
  cat = Categorie.find_by_id ( cmemory.category_id )
  fll2 = Following.find(:all,:conditions =>["followee_id=?",mem2.user_id])
  fcount2 = count(fll2)
  memusr2 = Memories_user.find(:all, :conditions=>["memory_id=? AND user_id=?",cm.memory_id,userid])
  memcount2 = count(memusr2)
  if memcount2 > 0
  fstatus = 1
  else
  fstatus = 0
  end
 
  msg[i]={"userid"=>us.id.to_s,"username"=>us.first_name,"gender"=>us.gender,"usercommentscount"=>countcm2.to_s,"comments"=>cm.content,"commentcreatedat"=>cm.created_at.to_s,"memoryname"=>mem.name,"memusername"=>usr2.first_name,"memcommentscount"=>countcm3.to_s,"memoryimage"=>pic,"memoryid"=>cm.memory_id.to_s,"likes"=>"535"}

 #msg[i]={"UserId"=>us.id.to_s,"UserName"=>us.first_name,"gender"=>us.gender,"usercommentscount"=>countcm2.to_s,"comments"=>cm.content,"commentcreatedat"=>cm.created_at.to_s,"memorieName"=>mem.name,"memusername"=>usr2.first_name,"coomentscount"=>countcm3.to_s,"MemorieImage"=>pic,"memorieId"=>cm.memory_id.to_s,"status"=>status.to_s,"categoryId"=>cat.id.to_s,"categoryName"=>cat.name,"memoriedecade"=>mem.decade.to_s,"memorieView"=>mem.views.to_s,"followscount"=>fcount2.to_s,"favstatus"=>fstatus.to_s}
  i=i+1
  end #for if @mem
  end #end for each

  else
  msg={"message"=>"please provide values"}
  end # for if
   render :json =>msg
  end #for def comments
 
 def followuser # completed
 followeeid = params[:followeeid]
 followerid = params[:followerid]
 msg = Array.new
 
if (!followeeid.nil? && !followerid.nil?)
ff = Following.find(:all,:conditions =>["followee_id=? AND follower_id=?",followeeid,followerid])
ffcount =count(ff)
if ffcount > 0
Following.delete_all(:followee_id => followeeid)
msg={"message"=>"User unfollowed successfully"}

else
ff=Following.new
ff.followee_id = followeeid
ff.follower_id = followerid
ff.save
msg={"message"=>"successfully inserted"} 
end # for if ffcount
else
msg={"messaage"=>"please provide vali=ues..."}
end #for if 
render :json =>msg
 end # for foloowuser

 def getcategories # completed

 msg = Array.new
i=0

  cat = Categorie.find(:all)
  cat.each do |c|
    msg[i]={c.id.to_s=>c.name}
    i=i+1

  end
  render :json =>{"categories"=>msg}
end # for def getcategories....

def getsinglememory # completed
# atre selecting the category it display all memory to that category..
#memoryid = params[:memoryid]
catid = params[:catid]
msg = Array.new
i=0
cat = Categorie.find_by_id(catid)
if !cat.nil?
  catmem = Categories_memorie.find(:all,:conditions=>["category_id=?",catid])
  catmem.each do |cm|
    mem = Memorie.find(:all,:conditions =>["id=?",cm.memory_id])

    mem.each do |m|
      img = Image.find_by_memory_id(m.id)
      if img.image_file_name.nil?
        image ="http://localhost:3000/assets/invite.png"
        else
        #image="http://s3.amazonaws.com/dyr_web/images/436/original/PortnoysComplaint.jpg?1339514893"
        image = "http://localhost:3000/assets/"+img.image_file_name
      end 
      #image = "http://localhost:3000/assets/invite.png"
      u = User.find_by_id(m.user_id)

#msg[0] = {"user_name"=>"Bryan Liff","user_id"=>1,"category_name"=>"COLLECTIBLES","name"=>"Gumby & Pokey","date_of_memory"=>"null","comments_count"=>2,"follows_count"=>0,"description"=>"These guys really know how to travel!","created_at"=>"2012-05-08T15:10:43-04:00","category_id"=>2,"views"=>182,"updated_at"=>"2012-08-23","decade"=>"1960s","is_anonymous"=>"false","image"=>"http://s3.amazonaws.com/dyr_web/images/1/original/gumby-1.jpg?1336504238","likes_count"=>10,"id"=>1}
      msg[i] = {"category_id"=>catid,"category_name"=>cat.name,"comments_count"=>m.comments_count,"created_at"=>m.created_at,"date_of_memory"=>m.decade,"description"=>m.description,"follows_count"=>"535","id"=>m.id,"image"=>image,"is_anonymous"=>m.is_anonymous,"like_count"=>"1","name"=>m.name,"updated_at"=>m.updated_at,"user_id"=>m.user_id,"user_name"=>u.first_name,"views"=>"35"}
      i=i+1

    end
  end
end
msg2 = Array.new
msg2={"memories"=>msg}
render :json =>msg2
end




 def getcomments #completed
 
  memoryid = params[:memoryid]
  i=0
  msg = Array.new
  if !memoryid.nil?
  cm =Comment.find(:all,:conditions =>["memory_id=?",memoryid])
  cm.each do |c|
      us = User.find_by_id(c.user_id)
     
t1 = c.created_at
t2 = t1.strftime("%Y-%m-%d %I:%M:%S")
    #msg[i]={"commentid"=>c.id.to_s,"content"=>c.content.to_s,"userid"=>c.user_id.to_s,"memoryid"=>c.memory_id.to_s,"createdat"=>t2,"username"=>us.first_name}
    


    msg[i]={"commentid"=>c.id.to_s,"content"=>c.content.to_s,"gender"=>us.gender,"userid"=>c.user_id.to_s,"memoryid"=>c.memory_id.to_s,"createdat"=>t2,"username"=>us.first_name}
    i=i+1
  end # foe each cm
  else 
  msg={"message"=>"please provide the values"}
  end # for if

  render :json =>msg
 end # for   def 

 def getshowdown # compleeted
 
i=0
msg = Array.new
image = "http://localhost:3000/assets/invite.png"
r1= Showdown.find(:all, :limit =>30)
r1.each do |r|
  u = User.find_by_id(r.user_id)
m = Array.new
m[0]={"memorynumber"=>"1","memorytext"=>r.memory_1,"memorypicture"=>image}
m[1]={"memorynumber"=>"2","memorytext"=>r.memory_2,"memorypicture"=>image}
m[2]={"memorynumber"=>"3","memorytext"=>r.memory_3,"memorypicture"=>image}
m[3]={"memorynumber"=>"4","memorytext"=>r.memory_4,"memorypicture"=>image}
m[4]={"memorynumber"=>"5","memorytext"=>r.memory_5,"memorypicture"=>image}




#@msg[0] = {"showdownid"=>"59",   "userid"=>"15",   "username"=>"Varma",   "createddate"=>"2012-06-06 09:47:39",   "status"=>0,   "questiontext"=>"Who is the most evil Disney villain?",   "questiondesc"=>"Disney Villains",   "commentscount"=>"3",   "choice"=>"10",   "answer"=>m}

msg[i]={"showdownid"=>r.id.to_s,"status"=>0,"userid"=>r.user_id.to_s,"username"=>u.first_name,"createddate"=>r.created_at,"questiontext"=>r.question,"questiondesc"=>"Ramesh Swamy Not decleared","commentscount"=>"0","choice"=>"10","answer"=> m}
 

#@msg[i]={"showdownid"=>r.id.to_s,"userid"=>r.user_id.to_s,"createddate"=>r.created_at,"questiontext"=>r.question,"choice1"=>r.memory_1,"choice2"=>r.memory_2,"choice3"=>r.memory_3,"choice4"=>r.memory_4,"choice5"=>r.memory_5,"choice1image"=>r.image_m1_file_name,"choice2image"=>r.image_m2_file_name,"choice3image"=>r.image_m3_file_name,"choice4image"=>r.image_m4_file_name,"choice5image"=>r.image_m5_file_name,"totalvotes"=>r.votes_count.to_s,"choice1votes"=>r.memory_1_votes_count.to_s,"choice2votes"=>r.memory_2_votes_count.to_s,"choice3votes"=>r.memory_3_votes_count.to_s,"choice4votes"=>r.memory_4_votes_count.to_s,"choice5votes"=>r.memory_5_votes_count.to_s}
i=i+1
end # for # each..
render :json =>msg
end # for getshowdown 
 
 def getuserdetails 
 
 userid = 156#params[:userid]
 i=0
 msg = Array.new
 if !userid.nil?
 r1 = User.find_by_id(userid)
r2 = Memory.find(:all,:conditions =>["user_id=?",userid]) 
r2count = count(r2)
r3 = Comment.find(:all,:conditions=>["user_id=?",userid])
r3count = count(r3)
 r4 = Following.find(:all,:conditions=>["followee_id=?",userid])
 r4count = count(r4)
 r5 = Following.find(:all,:conditions=>["follower_id=?",userid])
 r5count = count(r5)
  r6 = Memories_user.find(:all,:conditions=>["user_id=?",userid])
r6count = count(r6)
msg={"userid"=>userid.to_s,"username"=>r1.first_name,"gender"=>r1.gender,"location"=>r1.zip_code.to_s,"memoriescount"=>r2count.to_s,"commentscount"=>r3count.to_s,"followingcount"=>r5count.to_s,"followedcount"=>r4count.to_s,"rememberedmemories"=>r6count.to_s} 
 else 
 msg={"message"=>"please provide the values"}
end # for if 
 render :json =>msg
 end #for getuserdetails............ 

 

 def result  # completed
 msg = Array.new
 m= Array.new

showid = params[:showid]
userid = params[:userid] 
choice = params[:choice]
if ( !choice.nil? && !showid.nil? && !userid.nil? )
c1 = Showdown.find_by_id(showid)
if choice==1
k=c1.memory_1_votes_count
k=k+1
c1.memory_1_votes_count=k
#c1.update_attributes(:memory_1_votes_count => k)
end
if choice==2
k=c1.memory_2_votes_count
k=k+1
c1.memory_2_votes_count=k
#c1.update_attributes(:memory_2_votes_count => k)
end
if choice==3
k=c1.memory_3_votes_count
k=k+1
c1.memory_3_votes_count=k
#c1.update_attributes(:memory_3_votes_count => k)
end
if choice==4
k=c1.memory_4_votes_count
k=k+1
c1.memory_4_votes_count=k
#c1.update_attributes(:memory_4_votes_count => k)
end
if choice==5
k=c1.memory_5_votes_count
k=k+1
c1.memory_5_votes_count=k
#c1.update_attributes(:memory_5_votes_count => k)
end

k=c1.votes_count
k=k+1
c1.votes_count=k
#c1.update_attributes(:votes_count => k)

c1.save
t=c1.votes_count


m[0]={"memorynumber"=>"1","memorytext"=>c1.memory_1,"memorypicture"=>c1.image_m1_file_name,"percantage"=>((c1.memory_1_votes_count*100)/t),"choice"=>1}
m[1]={"memorynumber"=>"2","memorytext"=>c1.memory_2,"memorypicture"=>c1.image_m2_file_name,"percantage"=>((c1.memory_2_votes_count*100)/t),"choice"=>2}
m[2]={"memorynumber"=>"3","memorytext"=>c1.memory_3,"memorypicture"=>c1.image_m3_file_name,"percantage"=>((c1.memory_3_votes_count*100)/t),"choice"=>3}
m[3]={"memorynumber"=>"4","memorytext"=>c1.memory_4,"memorypicture"=>c1.image_m4_file_name,"percantage"=>((c1.memory_4_votes_count*100)/t),"choice"=>4}
m[4]={"memorynumber"=>"5","memorytext"=>c1.memory_5,"memorypicture"=>c1.image_m5_file_name,"percantage"=>((c1.memory_5_votes_count*100)/t),"choice"=>5}



msg={"message"=>"choice added","showdownid"=>showid,"userid"=>userid,"username"=>"ramesh","createddate"=>c1.created_at,"questiontext"=>c1.question,"commentscount"=>c1.votes_count,"choice"=>choice,"answer"=>m}
else
msg={"message"=>"please provide the values"}
end# for if...
render :json =>msg
 end # for result.....


  def search # completed
    
  
  msg = Array.new
  msg1 = Array.new
  
  userid = params[:userid]
  catid =  params[:catid].to_i
  search1 = params[:search]
  decade = params[:decade]
  

#  userid = 156#params[:userid]
 # catid = 3#params[:catid]
 # search1 = params[:search]
  if search1.length != 0
  
 i=0
 x = Categories_memorie.find(:all, :conditions=>["category_id=?",catid])
 
#msg =x
if decade !="Decade"

a2 = Memorie.where("name like ? AND decade=?" ,"%#{search1}%",decade )
 else
  
 a2 = Memorie.where("name like ?" ,"%#{search1}%" )
end
 
 #a2 = Memorie.where("name like ? AND decade=?","%#{search1}%" ,decade)
 a2.each do |a|
 b2 = User.find_by_id(a.user_id)

if catid==0

 #msg="Hai.."
 c2 = Categories_memorie.find(:all,:conditions=>["memory_id=?",a.id])
 else
 c2 = Categories_memorie.find(:all,:conditions=>["memory_id=? AND category_id=?",a.id,catid])
 
 
 end

 
  c2.each do |c|
     #msg[i]=c
d2 = Category.find_by_id(c.category_id)
#msg[i] = c
coment = Comment.find(:all,:conditions=>["memory_id=?",a.id])
  ccount = count(coment)
  i2 = Image.find_by_memory_id(a.id)
  if (i2.image_file_name !='null')
  pic=i2.image_file_name
else
pic="no-image.png"
end
  m = Memories_user.find(:all,:conditions=>["memory_id=?",a.id])
  mcount =count(m)
  mu = Memories_user.find(:all,:conditions=>["memory_id=? AND user_id=?",a.id,userid])
  mucount = count(mu)
  if mucount > 0
  fstatus = 1
  else 
  fstatus = 0
  end
  f = Following.find(:all,:conditions=>["followee_id=?",b2.id])
  fcount = count(f)
  ff = Following.find(:all,:conditions=>["followee_id=? AND follower_id=?",b2.id,userid])
    ffc = count(@ff)
  if ffc > 0
  status = 1
  else
  fsatus =0
  end
  pic ="http:\/\/myworkdemo.com\/doyourememberme\/services\/images\/20120620003547.jpg"
 

msg[i]={"categoryId"=>d2.id.to_s,"categoryName"=>d2.name,"memorieId"=>a.id.to_s,"memorieName"=>a.name,"memorieView"=>a.views.to_s,"memoriedecade"=>a.decade.to_s,"MemorieImage"=>pic,"MemoryCreatedDate"=>a.created_at,"UserId"=>b2.id.to_s,"UserName"=>b2.first_name,"coomentscount"=>ccount.to_s,"followscount"=>fcount.to_s,"status"=>status.to_s,"favstatus"=>fstatus.to_s,"favcount"=>mcount.to_s,"likes"=>0}
i=i+1
end # for c.each  
 end # for a.each
  
  
  #@msg[0]={"search"=>msg,"category"=>msg1}
  else 
   msg={"message"=>"please provide values"}
  end # for if
  
  render :json =>msg
  end # for  search....

 def signin 
 fname = params[:fname]
 lname = params[:lname]
 dob = params[:dob]
 email = params[:email]
 gender = params[:gender]
 password = params[:password]
 imagename=params[:imagename]
 imagetype=params[:type]
 size=params[:size] # here the sizeis 
 zipcode=params[:zipcode]
 aboutme=params[:aboutme]
 msg = Array.new
 if ( !fname.nil? && !lname.nil? && !dob.nil? && !email.nil? && !password.nil? )
e =User.where("email like ?","#{email}")
emcount = count(@e)
if emcount ==1
e.each do |gh|
msg={"message"=>"Email is already existed"}
end # for each
else
u=User.new
u.first_name=fname
u.last_name = lname
u.birth_year=dob
u.email = email
u.gender = gender
t=Time.now
u.haslocalpw=0
u.created_at=t
u.encrypted_password = password# here we can change the code as u need for encryption
u.profile_image_file_name=imagename
u.profile_image_content_type=imagetype
u.profile_image_file_size=size
u.zip_code=zipcode
u.about_me=aboutme
if u.save
b(email)
u1 = User.find_by_email(email)
msg={"message"=>"Signup successfull and login details are send to your Emails"}#"userid"=>@u1.id.to_s,"fname"=>@u1.first_name,"lname"=>lname,"dob"=>dob.to_s,"email"=>email
else 
msg={"message"=>"failed"}
end
end
 else
 msg={"message"=>"please provide values..."}
 end # for if
 render :json =>msg
 end  # for signin



def login

username = "ramesh@stellentsoft.com"#params[:UserName]
password = "ramsan"#params[:password]
msg =Array.new
u = User.find(:all, :conditions => ["email =? AND encrypted_password =?",username,password ])
          #find(:all,:conditions=>["followee_id=? AND follower_id=?",b2.id,userid])
if !u.nil?
  msg={"message"=>"successfull"}
else
  msg={"messaage"=>"failed"}
end
render :json =>msg

end




def views  #cokmpleeted
memoryid = params[:memoryid]
msg = Array.new
if !memoryid.nil?
v = Memorie.find_by_id(memoryid)
i=v.views.to_i
i=(i+1).to_s
v.update_attributes(:views => i)
msg={"message"=>"successfully views updated"}
else
msg={"message"=>"provide values"}
end
render :json =>msg
end # for vieww
 
 def usercomments 
 userid =  156#params[:userid]
 i=0
 msg = Array.new
 if !userid.nil?
 r0 = Comment.find(:all,:conditions=>["user_id =?",userid])
 r1count = count(r0)
r0.each do |r|
r2 = User.find_by_id(r.user_id)
r3 = Memorie.find_by_id(r.memory_id)
r4 = User.find_by_id(r3.user_id)
r5 = Image.find_by_memory_id(r.memory_id)
if r5.image_file_name != 'null'
pic=r5.image_file_name
else
pic="no-image.png"
end
r6 = Comment.find(:all,:conditions=>["memory_id =?",r.memory_id])
r6count = count(r6)
r9 = Following.find(:all,:conditions=>["followee_id=? AND follower_id=?",r3.user_id,userid])
r9count = count(r9)
if r9count > 0
status = 1
else
status = 0
end
rcm = Categories_memorie.find_by_memory_id(r.memory_id)
rwcat = Categorie.find_by_id(rcm.category_id)
r10 = Following.find(:all,:conditions=>["followee_id=?",r3.user_id])
r10count = count(r10)
r91 = Memories_user.find(:all,:conditions=>["memory_id=? AND user_id=?",r.memory_id,userid])
r91count = count(r91)
if r91count > 0
fstatus = 1
else
fstatus = 0
end
msg[i]={"UserId"=>r2.id.to_s,"UserName"=>r2.first_name,"gender"=>r2.gender,"usercommentscount"=>r1count.to_s,"comments"=>r.content,"commentcreatedat"=>r.created_at,"memorieName"=>r3.name,"memusername"=>r4.first_name,"coomentscount"=>r6count.to_s,"MemorieImage"=>pic,"memorieId"=>r.memory_id.to_s,"status"=>status.to_s,"categoryId"=>rwcat.id.to_s,"categoryName"=>rwcat.name,"memoriedecade"=>r3.decade.to_s,"memorieView"=>r3.views.to_s,"followscount"=>r10count.to_s,"favstatus"=>fstatus.to_s}
i=i+1
end # for each
 else
 msg={"message"=>"please provide values"}
end # for if 
 render :json =>msg
 end # for  usercomment

 def userfollowedby 
 
userid =12# params[:userid]
msg = Array.new
if !userid.nil?
i=0
r0 = Following.find(:all,:conditions=>["followee_id=?",userid])
r0.each do|r|
r1 = User.find_by_id(r.follower_id)
r2 = Memorie.find(:all,:conditions=>["user_id=?",r.follower_id])
r2count = count(r2)
r3 = Comment.find(:all,:conditions=>["user_id=?",r.follower_id])
r3count = count(r3)
r4 = Memories_user.find(:all,:conditions=>["user_id=?",r.follower_id])
r4count = count(r4)
msg[i]={"followedbyid"=>r.follower_id.to_s,"fusername"=>r1.first_name,"submitted"=>r2count.to_s,"comments"=>r3count.to_s,"fav"=>r4count.to_s}
i=i+1
end # for each....
else
msg={"message"=>"please provide values.."}
end
render :json =>msg
 end # for user followed by


 def userfollowing # completed
 userid = params[:userid]
msg = Array.new
if !userid.nil?
i=0
r0 = Following.find(:all,:conditions=>["followee_id=?",userid])
r0.each do|r|
r1 = User.find_by_id(r.follower_id)
r2 = Memorie.find(:all,:conditions=>["user_id=?",r.follower_id])
r2count = count(r2)
r3 = Comment.find(:all,:conditions=>["user_id=?",r.follower_id])
r3count = count(r3)
r4 = Memories_user.find(:all,:conditions=>["user_id=?",r.follower_id])
r4count = count(r4)
msg[i]={"followingid"=>r.follower_id,"fusername"=>r1.name,"submitted"=>r2count,"comments"=>r3count,"fav"=>r4count}
i=i+1
end # for each....
else
msg={"message"=>"please provide values.."}
end # for if
render :json=>msg
 end # for userfollowing......





def rememberedmemories #completed

 userid = params[:userid]
 i=0
msg = Array.new
 if !userid.nil?
 r1 = Memories_user.find(:all,:conditions =>["user_id=?",userid])
r1.each do |r|
r8 = Memorie.find_by_id(r.memory_id)
r2 = Comment.find(:all,:conditions=>["memory_id=?",r.memory_id])
r2c = count(r2)
r4 = Categories_memorie.find_by_memory_id(["?",r.memory_id])
r5 = Categorie.find_by_id(r4.category_id)
r3 = User.find_by_id(r8.user_id)
r6 = Image.find_by_memory_id(r8.id)
if r6.image_file_name == 'null'
pic = "no-image.png"
else
pic=r6.image_file_name
end
fc= Following.find(:all,:conditions=>["followee_id=?",r8.user_id])
fcount = count(fc)
f9 = Following.find(:all,:conditions=>["followee_id=? AND follower_id=?",r8.user_id,userid])
f9count = count(f9)
if f9count > 0
status =1
else
status =0
end
r91 = Memories_user.find(:all,:conditions=>["memory_id=? AND user_id=?",r8.id,userid])
r91c = count(r91)
if r91c > 0
fstatus = 1
else
fstatus = 0
end
rfw = Memories_user.find(:all,:conditions=>["memory_id=?",r8.id])
rfwc = count(rfw)
msg[i]={"categoryId"=>r5.id.to_s,"categoryName"=>r5.name,"UserId"=>r3.id.to_s,"UserName"=>r3.first_name,"memorieId"=>r8.id.to_s,"memoriedecade"=>r8.decade.to_s,"memorieName"=>r8.name,"memorieView"=>r8.views.to_s,"MemorieImage"=>pic,"MemoryCreatedDate"=>r8.created_at,"comentscount"=>r2c.to_s,"followscount"=>f9count.to_s,"followscount"=>r91c.to_s,"status"=>status.to_s,"favstatus"=>fstatus.to_s,"favcount"=>rfwc.to_s}
i=i+1
end # for r. each 
 else
#msg={"message"=>"please enter values"}
 end # for if
 
render :json =>msg
 end # for remembered memories







  def userrememberedmemories #completed
  userid = params[:userid]
  i=0
  msg = Array.new
  if !userid.nil?
  r0 = Memories_user.find(:all,:conditions=>["user_id=?",userid])
  r0.each do |r|
  r1 = Memorie.find_by_id(r.memory_id)
  r2 = Comment.find(:all,:conditions=>["memory_id=?",r.memory_id])
  r2c = count(r2)
  r4 = Categories_memorie.find_by_memory_id(r1.id)
  r5 = Category.find_by_id(r4.category_id)
  r3 = User.find_by_id(r1.user_id)
  r6 = Image.find_by_memory_id(r1.id)
  if r6.image_file_name == 'null'
  pic="no-image.png"
  else
  pic=r6.image_file_name
end
r10 = Following.find(:all,:conditions=>["followee_id=?",r.user_id])
follow = count(r10)
r11 = Following.find(:all,:conditions=>["followee_id=? AND follower_id=?",r.user_id,userid])
chk9 = count(r11)
if chk9 > 0
status = 1
else 
status = 0
end
c91 = Memories_user.find(:all,:conditions=>["memory_id=? AND user_id =?",r1.id,userid])
chk91 = count(c91)
if  chk91 > 0
fstatus = 1
else
fstatus = 0
end
rwf = Memories_user.find(:all,:conditions=>["memory_id=?",r1.id])
rwfc = count(rwf)
msg[i]={"categoryId"=>r5.id,"categoryName"=>r5.name,"UserId"=>r3.id,"UserName"=>r3.first_name,"memorieId"=>r1.id,"memorieName"=>r1.name,"memorieView"=>r1.views,"memoriedecade"=>r1.decade,"MemorieImage"=>pic,"MemoryCreatedDate"=>r1.created_at,"coomentscount"=>r2c,"followscount"=>follow,"status"=>status,"favstatus"=>fstatus,"favcount"=>rwfc}
i= i+1
  end # for each
  else
  
msg={"message"=>"please provide values"}
 end
     render :json =>msg
  end # for user remembered memories


  def emailconform
  userid = params[:userid]
  #text = params[:text]
  msg = Array.new
 if !userid.nil?
 #u = User.find_by_id(userid)
    Email.user_conform(userid).deliver
msg={"message"=>"Message successfully sent!"}
 else
 @msg={"message"=>"please provide values.."}
  end # for if
   render :json =>msg
  end # for email conform


def conform

    key = params[:key]    
    userid = params[:id]
    usr = User.find_by_email([id="?",userid])
    usr.update_attributes(:conformed_at =>Time.now, :haslocalpw =>0, :curent_sign_in_at =>Time.now)

    redirect_to :action => 'index'

    #render :json =>usr
 
end

def getmemoriesbycategory #completed
  msg = Array.new
  i=0

  cat = Categorie.find(:all)
  cat.each do |c|
    msg[i]={"catid"=>c.id,"catname"=>c.name,"catcreatedat"=>c.created_at,"catupdatedat"=>c.updated_at}
    i=i+1

  end
  render :json =>msg

end

def getdecade #completed
  a=Array.new
  msg = Array.new
  i=0
  mem=Memorie.find(:all)
  mem.each do|m|
    if !m.decade.nil?
      a[i]=m.decade
      i = i+1
    end
  end

  a=a.uniq
  a=a.sort
  i=0
  while i<a.length
    msg[i]={"decadeid"=>(i+1).to_s,"decade"=>a[i].to_s}
    i=i+1
  end

render :json =>msg
end



def getsuggestmemories # completed

userid= params[:userid]
#catid = params[:catid]


  i=0
  j=0
  msg1 = Array.new
  if (!userid.nil?)
  usr = User.find_by_id(userid)
  morefive=usr.birth_year+5
  lessfive=usr.birth_year-5
  
  user123 = User.where("birth_year <= :start_date AND birth_year >= :end_date",{:start_date => morefive, :end_date => lessfive})
  user123.each do |f|

  img = Image.find_by_user_id(f.id)
  if !img.nil?

  if img.image_file_name!='null'
    pic=img.image_file_name
    else 
    pic="no-image.png"
    end

  mem = Memorie.find_by_id(img.memory_id)
  if !mem.nil?
  catmem = Categories_memorie.find_by_memory_id(mem.id)
    if !catmem.nil?
  cat = Categorie.find_by_id(catmem.category_id)

  if !cat.nil?

  commemnt = Comment.find(:all, :conditions =>["memory_id=?",mem.id])
  commentcount = count(commemnt)
  fll = Following.find(:all,:conditions =>["followee_id=?",f.id])
  fcount = count(fll)

  if fcount > 0
  status=1
  else
  status = 0
  end
  memusr = Memories_user.find(:all, :conditions=>["memory_id=?",mem.id])
  memcount=count(memusr)
  memusr2 = Memories_user.find(:all, :conditions=>["memory_id=? AND user_id=?",mem.id,userid])
  memcount2=count(memusr2)
  if memcount2 > 0
  fstatus=1
  else
  fstatus=0
  end


  if (userid != f.id)
   if ( (lessfive <= f.birth_year) || ( f.birth_year >= morefive))
      if i < 19
   # msg1[i]={"categoryId"=>cat.id.to_s,"categoryName"=>cat.name,"memorieId"=>mem.id.to_s,"memorieName"=>mem.name,"memorieView"=>mem.views.to_s,"memoriedecade"=>mem.decade.to_s,"MemorieImage"=>pic,"MemoryCreatedDate"=>mem.created_at,"UserId"=>f.id.to_s,"UserName"=>f.first_name,"coomentscount"=>commentcount.to_s,"followscount"=>fcount.to_s,"status"=>status.to_s,"description"=>mem.description,"favstatus"=>fstatus.to_s,"favcount"=>memcount2.to_s};
     
     msg1[i]={"user_name"=>f.first_name,"user_id"=>f.id.to_s,"category_name"=>cat.name,"name"=>mem.name,"date_of_memory"=>mem.date_of_memory, "comments_count"=>mem.comments_count, "follows_count"=>fcount, "description"=>mem.description, "created_at"=>mem.created_at, "category_id"=>cat.id, "views"=>353, "updated_at"=>mem.updated_at, "decade"=>mem.decade.to_s, "is_anonymous"=>mem.is_anonymous,"image"=>pic,   "likes_count"=>"123", "id"=>mem.id}
 
   i =i +1
    end # end for count
end #for   if logic
  end #for if (userid != f.id)
  end # for cat
  end # for catmem
  end # for mem
  end # for img
  
  end # for f
end
msg = Array.new
msg ={"memories"=>msg1}
render :json =>msg

  end




  def userprofile # compleeted
    msg = Array.new

    userid = params[:userid]
    u= User.find_by_id(userid)
    m=Memorie.find(:all, :conditions =>["user_id=?",userid])
    mcount = count(m)
    c= Comment.find(:all, :conditions =>["user_id = ?",userid])
    ccount = count(c)
    f = Following.find(:all, :conditions =>["followee_id = ?",userid])
    fcount = count(f)
    fby = Following.find(:all, :conditions =>["follower_id = ?",userid])
    fbycount = count(fby)
    rm = Memories_user.find(:all, :conditions =>["user_id=?",userid])
    rmcount = count(rm)
    msg = {"id"=>u.id,"email"=>u.email,"username"=>u.first_name,"gender"=>u.gender,"locality"=>"","submittedmemoriescount"=>mcount,"commentscount"=>ccount,"followingcount"=>fcount,"followedby"=>fbycount,"rememberedmemories"=>rmcount,"commentstatus"=>"1","rememberstatus"=>"1","followstatus"=>"1","newsstatus"=>"1"}

render :json=>msg
  end


def memuserprofile # compleeted
  msg = Array.new
  memoryid = params[:memoryid]
  m = Memorie.find_by_id(memoryid)
  u = User.find_by_id(m.user_id)
  m = Memorie.find(:all, :conditions =>["user_id=?",u.id])
  mcount = count(m)
  c = Comment.find(:all,:conditions =>["user_id=?",u.id])
  ccount = count(c)
  f = Following.find(:all, :conditions =>["followee_id =?",u.id])
  fcount = count(f)


 fb = Following.find(:all, :conditions =>["follower_id =?",u.id])
 fbcount = count(fb)

rm = Memories_user.find(:all, :conditions =>["user_id=?",u.id])
rmcount = count(rm)



  msg = {"userid"=>u.id.to_s,"username"=>u.name,"gender"=>u.gender,"location"=>"","memoriescount"=>mcount.to_s,"commentscount"=>ccount.to_s,"followingcount"=>fcount.to_s,"followedcount"=>fbcount.to_s,"rememberedmemories"=>rmcount.to_s}





render :json =>msg
end

def usersubmittedmemories 
  msg = Array.new
  i=0
  userid = params[:userid]
  mem = Memorie.find(:all,:conditions =>["user_id=?",userid])
  mem.each do|m|
    img = Image.find_by_memory_id(m.id)
    if img.image_file_name !="null"
      image = "no_image.jpg"
    else
      image = img.image_file_name;
    end
    u = User.find_by_id(m.user_id)
    cat = Categories_memorie.find_by_memory_id(m.id)
    c= Categorie.find_by_id(cat.category_id)

  msg[i]={"memorieId"=>m.id,"memorieName"=>m.name,"memorydescription"=>m.description,"MemoryCreatedDate"=>m.created_at,"updatedat"=>m.updated_at,"memorieView"=>m.views,"memoriedecade"=>m.decade,"likes"=>"0","commentid"=>535,"coomentscount"=>m.comments_count,"MemorieImage"=>image,"UserId"=>u.id,"UserName"=>u.name,"gender"=>u.gender,"categoryId"=>c.id,"categoryName"=>c.name}
  i=i+1


  end
render :json =>msg

end

def usercomments #completed

msg = Array.new
userid = params[:userid]
i=0
u = User.find_by_id(userid)
com = Comment.find(:all, :conditions =>["user_id=?",userid])
com.each do|c|

m = Memorie.find_by_id(c.memory_id)
coment = Comment.find(:all,:conditions =>["memory_id=?",m.id])
cccount = count(coment)
u2 = User.find_by_id(m.user_id)
msg[i] ={"userid"=>u.id,"username"=>u.first_name,"comments"=>c.content,"commnetcreated"=>c.created_at,"memoryname"=>m.name,"likes"=>535,"memusername"=>u2.name,"memcommentscount"=>cccount,"memoryid"=>m.id}
i=i+1
end
render :json=>msg
end



def submitedmemory

memoryid = params[:memoryid]
  msg = Array.new
  i=0
m1 = Memorie.find_by_id(memoryid)
mem = Memorie.find(:all,:conditions =>["user_id=?",m1.user_id])
mem.each do|m|

img = Image.find_by_memory_id(m.id)
if img.image_file_name !="null"
  image = img.image_file_name
else
  image = "no_image.jpg"
end

u = User.find_by_id(m.user_id)
f = Following.find(:all,:conditions =>["followee_id=?",u.id])
fcount = count(f)
cat = Categories_memorie.find_by_memory_id(m.id)
c = Categorie.find_by_id(cat.category_id)
com  = Comment.find(:all, :conditions=>["memory_id=?",m.id])
cmcount = count(com)
  msg[i]={"memorieId"=>m.id,"memorieName"=>m.name,"memorieView"=>m.views,"memoriedecade"=>m.decade,"MemorieImage"=>image,"MemoryCreatedDate"=>m.created_at,"UserName"=>u.first_name,"UserId"=>u.id,"categoryId"=>c.id,"categoryName"=>c.name,"likes"=>"72","coomentscount"=>cmcount,"followscount"=>fcount},
i=i+1
end



render :json=>mem

end


end