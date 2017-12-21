% H-dome transform
% h = height of peaks
% n = size of neighborhood
function hdImage = hdTransform2(I, h, n)
    smallNumber = 1e-7;
    se = strel(ones(n));
    J = I-h;
    flag = 0;
%      [R C] = size(I);
%    count = 0;
    pI = J*0;
    while flag==0
        tempJ = min( imdilate(J, se), I);
        resud = sum( sum(abs(J-tempJ) ));
        J =  tempJ;
        pI = max(pI,J);
%        count = count +1
        if resud < smallNumber
            flag = 1;
        end
    end

    hdImage = I-pI;
%         figure
%     subplot(2,2,1)
%     imshow(I,[])
%     subplot(2,2,2)
%      imshow(pI,[])
%         subplot(2,2,3)
%      imshow( hdImage,[])
%      colormap('jet')
%      linkaxes;
end 