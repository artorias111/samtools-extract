process create_index {
    input:
    path fasta
    
    output:
    path fasta, emit: indexed_fasta
    path "*.fai", emit: index_file
    
    script:
    """
    samtools faidx ${fasta}
    """
}

process split_coordinates {
    input:
    path coordinates_file
    
    output:
    path "coordinates_parsed.txt", emit: coords_file
    
    script:
    """
    #!/usr/bin/env python3
    with open('${coordinates_file}', 'r') as f:
        with open('coordinates_parsed.txt', 'w') as out:
            for line in f:
                parts = line.strip().split()
                if len(parts) == 3:
                    contig, pos1, pos2 = parts
                    start = min(int(pos1), int(pos2))
                    stop = max(int(pos1), int(pos2))
                    out.write(f'{contig}\\t{start}\\t{stop}\\n')
    
    """
}

process samtools_extract { 
    publishDir 'results', mode: 'copy'
    
    input:
    tuple path(fasta), path(coordinates_file)

    output:
    path "*.fa", emit: extracted_fasta

    script:
    """
    while IFS=\$'\\t' read -r contig start stop; do
        samtools faidx ${fasta} \${contig}:\${start}-\${stop} > \${contig}.\${start}.\${stop}.fa
    done < ${coordinates_file}
    """
}
