% Testbed to validate CRC implementation

clear
clc

%% Test 1 - Small example packet
fprintf('\nTest 1:  Simple 8-byte packet\n')

% create test data
data = 48 + uint8(1:8)';    % ascii numbers 1-8
fprintf('Data:\n')
fprintf('         %.2X %.2X %.2X %.2X %.2X %.2X %.2X %.2X\n',data);
fprintf('\n')

% calculate CRC-16 checksum
checksum16 = '3c9d';            % valid CRC16 checksum
checksum16 = uint8(hex2dec(reshape(checksum16,2,[]).'));

%crc = crc16(data);
crctable16 = calc_crctable('1021');
crc = calc_crc(data,crctable16);
fprintf('CRC-16:   %.4X\n',crc)
fprintf('Expected: %s\n',upper(reshape(dec2hex(checksum16).',1,[])))

% calculate CRC-32 checksum
checksum32 = '9ae0daaf';        % valid CRC32 checksum
checksum32 = uint8(hex2dec(reshape(checksum32,2,[]).'));

crc = crc32(data);
fprintf('CRC-32:   %.8X\n',crc)
fprintf('Expected: %s\n',upper(reshape(dec2hex(checksum32).',1,[])))


%% Test 2 - 256 byte data packet
fprintf('\nTest 2:  256 byte data packet\n')

% define 256 byte data packet
data = '466F726D00000000118538BF0000C0000000019800007D80446174617B817B6F7B727B7D7BD67BB87B847BAE7B9A7C047BCD7BAB7BAB7B687B977B9E7B877B787B7A7BAD7B857B6F7B837BA07B4D7B7A7B6A7B587B727B7E7B977B777B677B677B6C7BAE7BE07B897BAF7BBD7BB87BA57BAD7B6F7B797BBD7B9C7B887BAF7B707B897B8C7B877BAF7BAA7BDA7B8F7B747B867BB77B8B7BAB7B8D7BA87BA77B5B7B757B897BA67B927BAB7B5E7B617B957B5D7B797BA87B7B7B9D7B777B577B647BB47BA57B877BBC7B797BBE7BBD7BAF7B8B7BB67BA87B817B6A7BD77B647B5C7BAC7B9E7B867B817B567BA87B8A7B8E7B737B6D7B4B7B9E7B8A7BA84D8A014F';

% convert to uint8 format
data = uint8(hex2dec(reshape(data,2,[]).'));

% extract checksum from data packet
checksum = data(end-3:end);       % valid 4-byte checksum is appended to end of each 252-byte packet
data = data(1:end-4);
fprintf('Data:\n')
for n=0:8:length(data)-8
    fprintf('0x%.4X   %.2X %.2X %.2X %.2X %.2X %.2X %.2X %.2X\n',n,data(n+1:n+8));
end
fprintf('0x%.4X   %.2X %.2X %.2X %.2X\n',n,data(n+1:n+4));
fprintf('\n')

% calculate CRC-32 checksum
crc = crc32(data);
fprintf('CRC-32:   %.8X\n',crc)
fprintf('Expected: %s\n',upper(reshape(dec2hex(checksum).',1,[])))

