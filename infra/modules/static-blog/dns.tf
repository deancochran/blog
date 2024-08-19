resource "aws_route53_zone" "main" {
    name = var.domain_name
}

resource "aws_route53_record" "main" {
    zone_id = aws_route53_zone.main.zone_id
    name    = var.domain_name
    type    = "A"
    alias {
        name                   = aws_cloudfront_distribution.main.domain_name
        zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
        evaluate_target_health = false
    }
}

resource "aws_acm_certificate" "main" {
    domain_name               = var.domain_name
    subject_alternative_names = ["*.${var.domain_name}"]
    validation_method         = "DNS"


    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_route53_record" "cert_validation" {
    for_each = {
        for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
        name   = dvo.resource_record_name
        record = dvo.resource_record_value
        type   = dvo.resource_record_type
        }
    }

    allow_overwrite = true
    name            = each.value.name
    records         = [each.value.record]
    ttl             = 60
    type            = each.value.type
    zone_id         = aws_route53_zone.main.zone_id
}

resource "aws_acm_certificate_validation" "main" {
    certificate_arn         = aws_acm_certificate.main.arn
    validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

