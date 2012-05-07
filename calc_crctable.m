function crctable = calc_crctable(poly)
% CALC_CRCTABLE  returns a lookup table for computing CRC checksums on a
% byte (uint8) of data.  CRCs can be calculated incrementally byte-wise and
% is more computationally efficient using a precalculated lookup table.
%
% TABLE = CALC_CRCTABLE(POLY) uses POLY to construct a 256 element table
%
% Note:  POLY can be either a hexadecimal string or an unsigned integer.
% If entering a string, the number of digits is mapped onto one of
% uint8/16/32/64.  POLY must be a fixed point data type if numeric.
%
% See also crc16 crc32 calc_crc

% Author:   Jason Gaudette
% Company:  Naval Undersea Warfare Center (Newport, RI)
% Phone:    401.832.6601
% Email:    jason.e.gaudette@navy.mil
% Date:     20110125

% check data type of POLY
assert(isnumeric(poly) || ischar(poly),'POLY must be either a hexadecimal string or numeric data type!');

% force floats into fixed point types
if isfloat(poly)
    warning('CALC_CRCTABLE:conversion','POLY must be a fixed point datatype.  Converting to uint32.')
    nbits = 32;                                     % assume datatype is uint32
elseif isnumeric(poly)
    nbits = find_precision(poly);                   % find fixed point polynomial precision
end

% force poly to be numeric
if ischar(poly)
    poly = strrep(lower(poly),'0x','');             % strip hex prefix if present
    nbits = 2^nextpow2(length(poly)*4);             % find CRC polynomial precision
    poly = hex2dec(poly);                           % convert to fixed precision integer
end

% assign function handle to data construct
datatype = str2func(sprintf('uint%d',nbits));

% perform bit reversal of polynomial and convert to unsigned integers
poly = datatype(bin2dec(fliplr(dec2bin(poly,nbits))));        % a bit arcane, but it works for up to 52 bits (need solution for 64-bit CRC)


%% iteratively calculate the lookup table
crctable = zeros(256,1,class(poly));       % initialize table
for byte=0:255
    crc = byte;
    for j=7:-1:0        % repeat 8 times
        mask = datatype(Inf)*bitand(crc,1);
        crc = bitxor(bitshift(crc,-1), bitand(poly,mask));
    end
    crctable(byte+1) = crc;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Helper functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nbits = find_precision(data)
% finds unsigned integer length of input data

fhandle = str2func(class(data));
obj = fhandle(Inf);        % create maximum valued object

nbits = length(dec2bin(obj));
