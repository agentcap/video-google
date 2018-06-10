function C = create_idx(dirname)
    %% Find SIFT features of all the images in the dataset
    frms = dir(strcat(dirname,'/*.png');
    img_cnt = size(frms,1); img_start = 1;
    desc_sz = 0;
    for i = 1:img_cnt
        filename = strcat(dirname,'/',frms(i).name)
        img = imread(filename);
        I = single(rgb2gray(img));
        [~,d] = vl_sift(I');
        desc(desc_sz+1:desc_sz+size(d',1),:) = d';
        desc_sz = desc_sz+size(d',1);
    end

    %% Cluster the Features and find top and bottom clusters
    no_clusters = 2000;
    [group_no,C] = kmeans(double(desc),no_clusters);

    cls_no = unique(group_no);
    [~,idx] = sort(histc(group_no,cls_no));
    rm_cls_idx = idx(floor([1:0.1*size(idx,1),0.9*size(idx,1):size(idx,1)]));

    %% Create index and find tf_idf for ranking
    index = zeros(no_clusters,img_cnt);
    tf = zeros(img_cnt,no_clusters);
    for i = 1:img_cnt
        filename = strcat(dirname,'/',frms(i).name)
        img = imread(filename);
        I = single(rgb2gray(img));
        [~,d] = vl_sift(I');
        x = knnsearch(C,double(d'));
        index(x,i) = 1;
        uv = unique(x);
        n  = histc(x,uv);
        tf(i,uv) = n;
        tf(i,:) = tf(i,:)/sum(tf(i,:));
    end
    tf = tf';
    idf = repmat(log2(img_cnt./sum(index,2)),1,img_cnt);

    %% Remove top and bottome clusters contributions
    tf(rm_cls_idx,:) = 0;
    idf(rm_cls_idx,:) = 0;
    tf_idf = tf .* idf;

    %% Save the clusters to file
    save('index.mat','C','tf_idf','img_cnt','no_clusters','dirname')
end