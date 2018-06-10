function idx = google_img(imgname)
	load('index.mat')
	img = imread(imgname);

	%% Find the tf for the query image
	test_tf = zeros(no_clusters,1);
	I = single(rgb2gray(img));
	[~,d] = vl_sift(I');
	x = knnsearch(C,double(d'));
	uv = unique(x);
	n  = histc(x,uv);
	test_tf(uv,1) = n;
	test_tf = test_tf/sum(test_tf);

	%% Sort the frames based on the ranking
	[~,idx] = sort(-sum(tf_idf.*repmat(test_tf,1,img_cnt)));
	idx = idx;

	%% Display top 10 results
	frms = dir(strcat(dirname,'/*.png');
	figure
	for i = 1:10
	    subplot(2,5,i)
	    imshow(strcat(dirname,'/',frms(i).name));
	    title(frms(i).name)
	end
end