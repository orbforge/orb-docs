---
title: Orb Detail View
shortTitle: Detail View
metaDescription: Explore the Orb app's detailed metrics screens to gain deeper insights into your network's performance over time.
section: Orb app
---

# Orb Detail View

The Orb detail view provides in-depth information about your network connectivity. This guide explains how to navigate and interpret the detailed metrics screens.

## Accessing the Detail View

You can access detailed metrics by tapping on any Orb card in the Orb Summary screen to open the detail view for that specific Orb.

## Common Elements

All detail views share certain common elements:

### Time Period Selector

At the top of each detail view, you'll find a time period selector that allows you to view data across different time periods, including:

- Last 1 minute
- Last 5 minutes
- Last 1 hour
- Last 24 hours

<img src="../../images/orb-app/global-time-selector.png" alt="Time Selector" width=40% style="margin-left: 2em;">

### Orb Score and Status Message

On the left, you'll see your overall Orb Score for the time period selected. You'll also find a status message describing the current state of your network connection.

<img src="../../images/orb-app/orb-score-and-status-message.png" alt="Orb Score Status" width=40% style="margin-left: 2em;">

There are indicators within the Orb Score that represent Responsiveness, Reliability, and Speed. When illuminated, the component is considered adequate for inclusion. If the indicator is dimmed, it indicates that while the the component is included, it may not be adequate (e.g. a stale speed score or not enough reliability data has been collected in the timeframe selected.)

<img src="../../images/orb-app/orb-score-indicators.png" alt="Score Indicators" width=30% style="margin-left: 2em;">

### Improve Connection

When your score is below 80, an "Improve Connection" button will appear. Tapping this button will provide you with tailored recommendations to improve your internet experience.

<img src="../../images/orb-app/improve-connection.png" alt="Improve Connection" width=40% style="margin-left: 2em;">

## Responsiveness and Reliability Detail

The Responsiveness detail view focuses on your connection's lag, latency, jitter, and packet loss for device-to-router and router-to-internet. Also included is DNS resolution time and time to first byte (TTFB) for the selected time period.

<img src="../../images/orb-app/responsiveness-card-expanded-v2.png" alt="Responsiveness" width=60% style="margin-left: 2em;">

The Reliability detail view focuses on your connection's stability. It includes the amount of time spent in the following states:
- Responsive
- Laggy
- Unresponsive
- Inactive

<img src="../../images/orb-app/reliability-card-expanded-v2.png" alt="Reliability" width=60% style="margin-left: 2em;">

The detail view displays Responsiveness and Reliability scores for the selected time period. Each of these contributes to your overall Orb Score. Tap on each card to expand and view more detailed metrics.

Each category is represented by:

- A score
- Detailed metrics
- Graphical representation of the data, when available

## Speed Detail

The Speed detail view focuses on your connection's throughput.

<img src="../../images/orb-app/speed-card-expanded-v2.png" alt="Speed" width=60% style="margin-left: 2em;">

### Content Download and Upload Speed Results

- Content download and upload speed measurements are performed on a one-hour cadence by default.
- These measurements are included in the Speed score and Orb Score, even when the measurement was performed outside of the selected time period.
- To disable or change the frequency of content speed measurements, use the dropdown menu in the expanded Speed card.

<img src="../../images/orb-app/speed-cadence.png" alt="Speed" width=60% style="margin-left: 2em;">

- The dropdown menu allows you to select from the following options:
  - Every 1 hour (default)
  - Every 4 hours
  - Every 6 hours
  - Every 24 hours
  - Never (disables content speed measurements)
- Content speed measurements can also be initiated at any time by the user.

### Peak Download and Upload Speed Results

- Peak download and upload speed measurements can be initiated at any time by the user.
- These results are informational only and not included in your speed or Orb Score.

## Next Steps

To learn more about specific Orb metrics:

- [Understanding Speed metrics](/docs/orb-app/speed.md)
- [Understanding Reliability metrics](/docs/orb-app/reliability.md)
- [Understanding Responsiveness metrics](/docs/orb-app/responsiveness.md)
