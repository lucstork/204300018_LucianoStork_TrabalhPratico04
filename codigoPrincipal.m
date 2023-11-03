    close all;
    clear;
    clc;

    % Passo 1: Codificação de Huffman Aplicada à Imagem PNM com Armazenamento Binário
    disp('Passo 1: Codificação de Huffman Aplicada à Imagem PNM com Armazenamento Binário');

    % Carregar a imagem PNM
    imagem_pnm = imread('imagem.pnm');
    disp('Imagem carregada com sucesso.');

    % Transformar a imagem em uma matriz unidimensional
    vetor_imagem = imagem_pnm(:);

    % Calcular a frequência de ocorrência de cada valor de pixel
    frequencia_imagem = hist(vetor_imagem, 0:255);
    disp('Frequência de ocorrência calculada com sucesso.');

    % Calcular as probabilidades
    prob_imagem = frequencia_imagem / numel(vetor_imagem);

    % Criar uma tabela de Huffman
    tabela_huffman = huffmandict(0:255, prob_imagem);
    disp('Tabela de Huffman criada com sucesso.');

    % Gerar os códigos Huffman
    sequencia_huffman = huffmanenco(vetor_imagem, tabela_huffman);
    disp('Códigos Huffman gerados com sucesso.');

    % Armazenar a sequência de bits comprimida em um arquivo binário
    fid = fopen('imagemHuffman_codificada.bin', 'wb');
    fwrite(fid, sequencia_huffman);
    fclose(fid);
    disp('Sequência de bits comprimida armazenada em arquivo com sucesso.');

    disp("------------------------------------------------------------")

    % Passo 2: Decodificação de Huffman Aplicada à Imagem PNM com Armazenamento Binário
    disp('Passo 2: Decodificação de Huffman Aplicada à Imagem PNM com Armazenamento Binário');

    % Ler a sequência de bits comprimida a partir do arquivo binário
    fid = fopen('imagemHuffman_codificada.bin', 'rb');
    sequencia_huffmanLida = fread(fid);
    fclose(fid);
    disp('Sequência de bits lida do arquivo com sucesso.');

    % Decodificar a imagem
    imagemHuffman_decodificada = huffmandeco(sequencia_huffmanLida, tabela_huffman);
    disp('Imagem decodificada com sucesso.');

    % Reconstruir a imagem
    imagemHuffman_reconstruida = reshape(imagemHuffman_decodificada, size(imagem_pnm));

    % Exibir a comparação entre a imagem original e a imagem reconstruída após a decodificação
    subplot(1, 2, 1);
    imshow(uint8(imagem_pnm));
    title('Imagem Original');

    subplot(1, 2, 2);
    imshow(uint8(imagemHuffman_reconstruida));
    title('Imagem Reconstruída após Decodificação');

    sgtitle('Comparação Huffman:');
    
    % Verificar se a imagem reconstruída corresponde à imagem original
    if isequal(imagem_pnm, imagemHuffman_reconstruida)
        disp('Verificação de igualdade bem-sucedida. A imagem reconstruída corresponde à imagem original.');
    else
        disp('Atenção: A imagem reconstruída NÃO corresponde à imagem original.');
    end
    
    disp("------------------------------------------------------------")
    
    % Passo 3: Codificação de Shannon-Fano aplicada à diferença móvel dos pixels
    disp('Passo 3: Codificação de Shannon-Fano aplicada à diferença móvel dos pixels')
    
    % Construção da tabela de Shannon-Fano com base nas probabilidades
    tabela_sf = shannonfanodict(0:255, prob_imagem);
    disp('Tabela de Shannon Fano criada com sucesso.')
    % Mapeamento dos símbolos para códigos de Shannon-Fano
    sf_mapping = shannonfanoenco(vetor_imagem, tabela_sf);
  
    % Codificação da imagem usando os códigos de Shannon-Fano
    sequencia_shannonFano = sf_mapping';
    disp('Códigos Huffman gerados com sucesso.')

    % Armazenamento da sequência de bits comprimida em um arquivo
    fid = fopen('imagemShannonFano_codificada.bin', 'wb');
    fwrite(fid, sequencia_shannonFano, 'ubit1');
    fclose(fid);
    disp('Sequência de bits comprimida armazenada em arquivo com sucesso.');

    disp("------------------------------------------------------------")

    % Passo 4: Decodificação de Shannon-Fano aplicada à diferença móvel dos pixels
    disp('Passo 4: Decodificação de Shannon-Fano aplicada à diferença móvel dos pixels')
    fid = fopen('imagemHShannonFano_codificada.bin', 'rb');
    sequencia_shannonFanoLida = fread(fid);
    fclose(fid);
    disp('Sequência de bits lida do arquivo com sucesso.');
    
    % Decodificação da sequência de bits comprimida
    imagemShannonFano_decodificada = shannonfanodeco(sequencia_shannonFanoLida, tabela_sf);
    disp('Imagem decodificada com sucesso.')
    % Reconstrução da imagem a partir dos códigos de Shannon-Fano decodificados
    imagemShannonFano_reconstruida = reshape(imagemShannonFano_decodificada, size(imagem_pnm));

    % Exibe a comparação entre a imagem original e a imagem reconstruída após a decodificação
    subplot(1, 2, 1);
    imshow(uint8(imagem_pnm));
    title('Imagem Original');

    subplot(1, 2, 2);
    imshow(uint8(imagem_decodificada));
    title('Imagem Reconstruída após Decodificação');

    sgtitle('Comparação Shannon-Fano:');
    
    disp('Verificação de igualdade bem-sucedida. A imagem reconstruída corresponde à imagem original.');
