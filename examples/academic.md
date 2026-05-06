---
title: "Sparse Attention Mechanisms in Long-Context Transformers"
subtitle: "A Comparative Study of Sliding Window, Dilated, and Learned Sparsity"
author: "Jane Doe, John Smith"
date: "2025-10-15"
description: "We compare three sparse attention strategies on long-context language modeling benchmarks."
keywords: [transformers, attention, sparsity, long-context, nlp]
version: "preprint v1"
---

# Abstract

Dense self-attention scales quadratically with sequence length, limiting transformer applicability to long-document understanding. We compare three sparse attention mechanisms — sliding window, dilated, and learned routing — on the **PG-19** and **arXiv** long-context benchmarks. Learned routing achieves **94.2%** of dense-attention perplexity at **17%** of the FLOPs, suggesting that adaptive sparsity is a viable path to efficient long-context modeling.

**Keywords:** sparse attention, transformers, long-context, efficient inference

# 1. Introduction

The self-attention operator [@vaswani2017attention] computes pairwise interactions between every pair of tokens, yielding $\mathcal{O}(n^2)$ time and memory complexity in the sequence length $n$. For documents exceeding $n = 8192$ tokens, this cost dominates training and inference budgets.

Three families of sparse attention have emerged to address this:

1. **Sliding window** [@beltagy2020longformer] — each token attends to a fixed local neighborhood
2. **Dilated** [@child2019sparse] — strided attention patterns at multiple scales
3. **Learned** [@roy2021efficient] — content-dependent routing of attention budget

This paper provides the first head-to-head comparison of all three under matched parameter counts and training budgets.

# 2. Method

## 2.1 Architecture

All models use a 12-layer decoder-only transformer with $d_\text{model} = 768$, 12 attention heads, and FFN dimension 3072. Total parameter count is held constant at **124M** across configurations.

## 2.2 Attention variants

The attention budget per query is fixed at $k = 256$ keys regardless of sequence length:

$$
\text{Attn}(Q, K, V) = \text{softmax}\left(\frac{Q K_S^\top}{\sqrt{d}}\right) V_S
$$

where $S \subset \{1, \ldots, n\}$ with $|S| = k$ is selected by the sparsity policy.

## 2.3 Training

Models are pretrained on **The Pile** for 100B tokens with sequence length $n = 16{,}384$. Optimizer: AdamW, peak learning rate $3 \times 10^{-4}$, cosine decay.

# 3. Results

| Model | PG-19 PPL ↓ | arXiv PPL ↓ | FLOPs (rel.) |
|---|---:|---:|---:|
| Dense (baseline) | 12.4 | 8.1 | 1.00× |
| Sliding window | 14.2 | 9.6 | 0.13× |
| Dilated | 13.8 | 9.1 | 0.13× |
| **Learned routing** | **13.1** | **8.6** | **0.17×** |

Learned routing recovers **94.2%** of dense-attention quality (measured as inverse-perplexity ratio) while using **17%** of the FLOPs.

# 4. Discussion

The gap between learned and fixed sparsity widens with sequence length, suggesting that adaptive routing matters most when the search space is large. Future work should investigate whether learned routing can be distilled into a fixed pattern post-hoc, combining the quality of learned sparsity with the inference speed of static patterns.

# 5. Conclusion

Sparse attention with learned routing is a Pareto-optimal point on the quality/cost frontier for long-context language modeling. We release code and checkpoints at `github.com/example/sparse-attention`.

# References

[@vaswani2017attention] Vaswani et al. *Attention Is All You Need.* NeurIPS 2017.
[@beltagy2020longformer] Beltagy et al. *Longformer: The Long-Document Transformer.* arXiv 2020.
[@child2019sparse] Child et al. *Generating Long Sequences with Sparse Transformers.* arXiv 2019.
[@roy2021efficient] Roy et al. *Efficient Content-Based Sparse Attention with Routing Transformers.* TACL 2021.
