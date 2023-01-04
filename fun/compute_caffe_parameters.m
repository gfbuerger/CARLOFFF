## usage: counter = compute_caffe_parameters (net)
##
## count network parameters
function counter = compute_caffe_parameters (net)

		    % get the list of layers
   layers_list = net.layer_names;
		    % for those layers which have parameters, count them
   counter = 0;
   for j = 1:length(layers_list)
      if ~isempty(net.layers(layers_list{j}).params)
	 feat = net.layers(layers_list{j}).params{1}.get_data();
	 counter = counter + numel(feat) ;
      end
   end
   
endfunction
