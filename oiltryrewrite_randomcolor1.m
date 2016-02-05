clear all
%x=imread('/Users/xuchuwen/Downloads/Central-Park-algemeen.jpg');
x=imread('/Users/Jingmei/Desktop/8.jpg');
width=size(x,2);
height=size(x,1);
% mypaint=uint8(zeros(height,width));

intensity=150;
radius=4;

%add contrast
I=rgb2gray(x);
I=im2double(I);
I=1.3*log(I+1);
I=im2uint8(I);

% blurry
% down-sampling the intensity image
I=floor(I*(intensity/255));
mypaint=zeros(height,width,3);
temp=double(mypaint);

for m=1:width
    for n=1:height
        counter=zeros(1,intensity+1);
        color=zeros(3,intensity+1);
        
        for i=(m-radius):(m+radius)
            for j=(n-radius):(n+radius)
                if i>0 &&j>0 && i<=width && j<=height     
                    
                    %luminance
                    lum=I(j,i)+1;
                    %red
                    color(1,lum)=x(j,i,1);
                    %green
                    color(2,lum)=x(j,i,2);
                    %blue
                    color(3,lum)=x(j,i,3);
                    %times that one luminance appears in the patch
                    counter(lum)=counter(lum)+1;
                    
                end
                
            end
        end
        
        %find the maximum occuring luminance
        [mm,index]=max(counter);
        %add random value to dominant color
        [domincolor,idx]=max(color(:,index));
        r1=randi([-20,5]);
        
        if idx==1
            mypaint(n,m,1)=color(1,index)+r1;
            mypaint(n,m,2)=color(2,index)-r1;
            mypaint(n,m,3)=color(3,index)-r1;
        end
        if idx==2
            mypaint(n,m,1)=color(1,index)-r1;
            mypaint(n,m,2)=color(2,index)+r1;
            mypaint(n,m,3)=color(3,index)-r1;
        end
        if idx==3
            mypaint(n,m,1)=color(1,index)+r1;
            mypaint(n,m,2)=color(2,index)-r1;
            mypaint(n,m,3)=color(3,index)+2*r1;
%         else
%             mypaint(n,m,1)=color(1,index);
%             mypaint(n,m,2)=color(2,index);
%             mypaint(n,m,3)=color(3,index);
            
        end
        
        
        
    end
    
end
figure(1)
imshow(uint8(mypaint))

% Gaussian Blur
 G=fspecial('gaussian',[3 3],0.6);
% %G=fspecial('average');
 mypaint2=floor(imfilter(mypaint,G));

%figure(2)
%imshow(uint8(mypaint2))

% add shadow
mypaint3=zeros(height,width,3);
painttemp=double(mypaint2);
for i=2:height-1
    for j=2:width-1
        incre=painttemp(i-1,j-1,:)-painttemp(i+1,j+1,:);
        closeness=floor(height/2)-abs(i-floor(2*height/3))+floor(width/2)-abs(j-floor(width/2));
        cl=exp(closeness/(height+width));
        mypaint3(i,j,:)=-abs(incre).*cl*1.1+painttemp(i,j,:);
    end
end
% figure(3)
% mypaint_emboss=mypaint3/250;
% imshow(mypaint_emboss);
% imwrite(mypaint_emboss,'5.jpg','jpg')
% 
% 
%emphasize edge
mypaint4=zeros(height,width,3);
painttemp=double(mypaint3);
for i=2:height-1
    for j=2:width-1
        incre=painttemp(i-1,j-1,:)-painttemp(i+1,j+1,:);
        closeness=floor(height/2)-abs(i-floor(2*height/3))+floor(width/2)-abs(j-floor(width/2));
        cl=exp(closeness/(height+width));
        mypaint4(i,j,:)=abs(incre).*cl*0.5+painttemp(i,j,:);
    end
end
% figure(4)
% mypaint_emboss=mypaint4/280;
% imshow(mypaint_emboss);
%imwrite(mypaint_emboss,'2.jpg','jpg')
% 
% 
% 
% add emboss
mypaint4=zeros(height,width,3);
painttemp=double(mypaint3);
for i=2:height-1
    for j=2:width-1
        incre=painttemp(i-1,j-1,:)-painttemp(i+1,j+1,:);
        closeness=floor(height/2)-abs(i-floor(2*height/3))+floor(width/2)-abs(j-floor(width/2));
        cl=exp(closeness/(height+width));
        mypaint4(i,j,:)=incre.*cl*0.5+painttemp(i,j,:);
    end
end
% figure(6)
% mypaint_emboss=mypaint4;
% imshow(uint8(mypaint_emboss));
% imwrite(mypaint_emboss,'3.jpg','jpg')
% 
% %change brightness
% bright=repmat(10,height,width);
% for i=1:3
% mypaint2(:,:,i)=mypaint2(:,:,i)+bright;
% end
% figure(7)
% mypaint_emboss=mypaint2/250;
% imshow(mypaint_emboss);
% imwrite(mypaint_emboss,'4.jpg','jpg')


% %add cloth texture
% for i=1:15
%     rshu=randi([0 20]);
%     rheng=randi([0 20]);
%     rlen=randi([0 min(height,width)-50]);
%     shu=repmat(rshu,rlen,1);
%     heng=repmat(rheng,1,rlen);
%     rx1=randi([0 height-rlen]);
%     ry1=randi([0 width-rlen]);
% 
% 
%     rx2=randi([0 height-rlen]);
%     ry2=randi([0 width-rlen]);
% 
%     for j=1:3
% 
%         mypaint2(rx1:rx1+rlen-1,ry1,j)=floor(mypaint2(rx1:rx1+rlen-1,ry1,j)+0.8*shu);
%         mypaint2(rx1:rx1+rlen-1,ry1+1,j)=floor(mypaint2(rx1:rx1+rlen-1,ry1+1,j)-0.8*shu);
%         mypaint2(rx2,ry2:ry2+rlen-1,j)=floor(mypaint2(rx2,ry2:ry2+rlen-1,j)+0.8*heng);
%         mypaint2(rx2+1,ry2:ry2+rlen-1,j)=floor(mypaint2(rx2+1,ry2:ry2+rlen-1,j)-0.8*heng);
%         
%        
%     end
% end

%add texture
y=imread('/Users/Jingmei/Desktop/3t.jpg');
I=double(rgb2gray(y));
BW=edge(I,'canny');
J=1-BW;
J=~J;
figure(9)
imshow(J)
J=J.*10;
m=size(J,1);
n=size(J,2);

%mypaint4=mypaint3;
for i=1:20
    h=randi([1 height-m]);
    z=randi([1 width-n]);
    mypaint4(h:h+m-1,z:z+n-1,1)=mypaint4(h:h+m-1,z:z+n-1,1)+J;
    mypaint4(h:h+m-1,z:z+n-1,2)=mypaint4(h:h+m-1,z:z+n-1,2)+J;
    mypaint4(h:h+m-1,z:z+n-1,3)=mypaint4(h:h+m-1,z:z+n-1,3)+J;
end

figure(8)
imshow(uint8(mypaint4))
imwrite(uint8(mypaint4),'8r1.jpg','jpg')

%add saturation
% VV=repmat(20,height,width);
% SS=repmat(0.05,height,width);
% mypainttry=rgb2hsv(mypaint4);
% mypainttry(:,:,2)=mypainttry(:,:,2)-SS;
% mypainttry(:,:,3)=mypainttry(:,:,3)+VV;
% mypaint4=hsv2rgb(mypainttry);

% Gaussian Blur
%  G=fspecial('gaussian',[3 3],0.6);
%  mypaint5=floor(imfilter(mypaint4,G));
%imwrite(uint8(mypaint4),'2r2.jpg','jpg')

