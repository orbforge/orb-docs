---
title: Orb Scores & Metrics
shortTitle: Scores & Metrics
metaDescription: Understand how Orb calculates network performance scores and what the different metrics mean for your internet experience.
section: Orb app
---

# Orb Scores & Metrics

Orb provides a comprehensive view of your network connectivity through a variety of scores and metrics. This guide explains how these measurements work and what they mean for your internet experience.

## The Orb Score

The Orb Score is a single number from 0-100 that represents the overall health of your network. It's calculated by combining scores from three categories of performance:

- **Responsiveness**: How fast and smoothly a network responds to requests
- **Reliability**: How consistent and dependable the network is
- **Speed**: How fast a network can transfer data to and from a device

A higher Orb Score indicates better overall performance. The score is color-coded for quick assessment:

- **Green (90-100)**: Excellent performance
- **Light Green (80-89)**: Good performance with room for improvement
- **Yellow (70-79)**: Okay performance with room for improvement
- **Orange (50-69)**: Fair performance with noticeable issues
- **Red (0-49)**: Poor performance that needs attention

<Image src="../../images/orb-app/orb-score-scale.png" alt="Orb Score Scale" />

## Key Metrics

Each of the three categories provides insights into a different aspect of your network performance.

### Responsiveness

[Responsiveness](/docs/orb-app/responsiveness.md) measures how quickly and smoothly your network responds to requests. It includes:

- **Lag**: The time it takes to get an applicable response from an internet service. Reported in milliseconds (ms) and includes best, worst, and typical values.
- **Latency**: The delay measured when sending and receiving packets, reported in milliseconds (ms).
- **Jitter**: The variation in latency over time, reported in milliseconds (ms).
- **Packet Loss**: The percentage of data packets that are lost or delayed during transmission. High packet loss or significantly delayed packets will impact lag due to packet resubmission.

Responsiveness is particularly important for interactive activities like gaming, video calls, and web browsing.

### Reliability

[Reliability](/docs/orb-app/reliability.md) measures how consistently your connection works without interruptions. It includes:

- **Responsiveness over time**: The time your connection is responsive
- **Packet Loss**: The time in which data packets are lost or delayed during transmission. High packet loss or significantly delayed packets will impact lag due to packet resubmission.

Reliability is crucial for all online activities, especially those that require a continuous connection like video calls or online gaming.

### Speed

[Speed](/docs/orb-app/speed.md) measures how quickly data can be transferred to and from a devices. It includes:

- **Content Download Speed**: How quickly you can receive data, reported in Mbps
- **Content Upload Speed**: How quickly you can send data, reported in Mbps

Orb's primary speed measurements are important for activities like streaming videos, downloading files, video conferencing, and other relevant day-to-day activities.

While peak speed measurements are available and can be initiated by the user at any time, they are informational only and not included in the Orb Score. The Orb Score is based on content speed measurements only, which are performed on a regular cadence.

## Interpreting Your Scores

When reviewing your Orb scores and metrics:

1. **Look for patterns**: Are there specific times when performance drops?
2. **Consider your usage**: Different activities have different requirements
3. **Compare to expectations**: How does performance compare to your internet plan?
4. **Track changes over time**: Is performance improving or deteriorating?

## Sharing Your Scores

- You can share your Orb scores with support teams or community forums to get help diagnosing issues.
- Use the "Share Orb Score" feature in the Orb app to generate a link that includes your Orb Scores.
- This feature can be found by expanding the Orb menu (...) from either the summary or detail view of the Orb app.

<Image src="../../images/orb-app/orb-score-share-menu.png" alt="Orb Score Share Menu" width=40% style="margin-left: 2em;"/>

- This will generate a link that you can copy and share with others, allowing them to view your Orb Scores without needing to log in to your account.

<Image src="../../images/orb-app/orb-score-share.png" alt="Orb Score Share" width=40% style="margin-left: 2em;"/>

## Next Steps

To learn more about specific metrics, check out these detailed guides:

- [Understanding Speed metrics](/docs/orb-app/speed.md)
- [Understanding Reliability metrics](/docs/orb-app/reliability.md)
- [Understanding Responsiveness metrics](/docs/orb-app/responsiveness.md)
