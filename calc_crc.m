function crc = calc_crc(data,poly,varargin)
% CALC_CRC  calculates the cyclic redundancy check on a data stream with the specified polynomial
%
% CRC = CALC_CRC(DATA,POLY) applies the polynomial POLY to DATA and returns
% an N-bit unsigned integer of the same length as POLY
%
% CRC = CALC_CRC(DATA,CRCTABLE) uses the 256 element lookup table for byte-wise CRC
% calculation
%
% Note:  Byte-wise CRC calculation is much more efficient for a large
% dataset and/or large number of calls to calc_crc.  CRCTABLE can be
% calculated initially by using the calc_crctable function.
%
% Based on a C-code implementation located at http://www.hackersdelight.org/crc.pdf
%
% See also crc16 crc32 calc_crctable

% Author:   Jason Gaudette
% Company:  Naval Undersea Warfare Center (Newport, RI)
% Phone:    401.832.6601
% Email:    jason.e.gaudette@navy.mil
% Date:     20110125

% validate input polynomial/lookup table
if ischar(poly) || isscalar(poly)
    % convert to uint if necessary
    if ischar(poly)
        poly = strrep(lower(poly),'0x','');             % strip hex prefix if present
        nbits = 2^nextpow2(length(poly)*4);             % find CRC polynomial precision
        poly = hex2dec(poly);                           % convert to fixed precision integer

        % perform bit reversal of polynomial and convert to unsigned int
        datatype = str2func(sprintf('uint%d',nbits));
        poly = datatype(bin2dec(fliplr(dec2bin(poly,nbits))));        % a bit arcane, but it works for up to 52 bits (need solution for 64-bit CRC)
    elseif isfloat(poly)
        warning('CALC_CRCTABLE:conversion','POLY must be a fixed point datatype.  Converting to uint32.')
        poly = uint32(poly);                                     % assume datatype is uint32
    end
else
    % check for a properly formed lookup table
    assert(isnumeric(poly) && numel(poly) == 256,'CRCTABLE must be a 256 element numeric array')
end

% force data into unsigned 8-bit sections
% if ~isa(data,'uint8')
%     typecast(data,'uint8')     % TBD - this won't likely work for all cases
% end


datatype = str2func(class(poly));   % get datatype function handle for CRC code
crc = datatype(Inf);                % zero out CRC code (w/ bits preflipped)

%% default to bitwise calculation if user entered CRC polynomial
if isscalar(poly)

    % iterate over each data byte
    for i=1:length(data)
        byte = datatype(data(i));       % Get next byte.
        crc = bitxor(crc,byte);
        
        % iterate over each bit
        for j=1:8
            mask = datatype(Inf)*bitand(crc,1);
            crc = bitxor(bitshift(crc,-1), bitand(poly,mask));
        end
    end

%% default to bytewise calculation if using precomputed lookup table
else

    % convert each data byte to CRC datatype
    data = datatype(data);
    
    % iterate over each data byte
    for i=1:length(data)
        byte = data(i);       % Get next byte.
        
        % lookup CRC for current data byte
        code = poly(bitand(bitxor(crc,byte),255)+1);
        crc = bitxor(bitshift(crc,-8), code);
    end

end

% flip all resulting bits
crc = bitxor(crc,datatype(Inf));
